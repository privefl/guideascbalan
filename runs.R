library(dplyr)
library(lubridate)
library(httr2)

get_runs <- function(oldest = "2024-08-06", cache = "runs.tsv", max_age = 7, force = FALSE) {
  old <- if (file.exists(cache)) {
    # stored as local Paris time (no "Z"): parse as such
    readr::read_tsv(cache, col_types = readr::cols(id = "c", start = "c", .default = "d")) %>%
      mutate(start = ymd_hms(start, tz = "Europe/Paris"))
  } else NULL
  # skip the API call if the cache was updated recently enough
  if (!force && !is.null(old) &&
      difftime(now(), file.mtime(cache), units = "days") < max_age) {
    return(old)
  }
  key <- Sys.getenv("INTERVALS_API_KEY")
  if (key == "") {
    stop("INTERVALS_API_KEY not found. Set it in ~/.Renviron, then run readRenviron('~/.Renviron').")
  }
  # fetch from last cached day (inclusive, in case of several runs that day)
  from <- if (is.null(old)) oldest else as.character(as_date(max(old$start, na.rm = TRUE)))
  if (is.na(from)) stop("Could not determine last cached date: check ", cache)
  new <- tryCatch(
    request("https://intervals.icu/api/v1/athlete/0/activities") %>%
      req_auth_basic("API_KEY", key) %>%
      req_url_query(oldest = from, newest = as.character(today())) %>%
      req_perform(),
    httr2_http_401 = function(e) stop("Invalid intervals.icu API key (HTTP 401). Regenerate it in Settings > Developer Settings.", call. = FALSE),
    httr2_http_403 = function(e) stop("Access denied by intervals.icu (HTTP 403). Check the key and the athlete ID.", call. = FALSE)
  ) %>%
    resp_body_json(simplifyVector = TRUE) %>%
    as_tibble()
  if (nrow(new) > 0) {
    # minutes spent in HR zones from..to (zones as configured in intervals.icu)
    zmin <- function(z, from, to = Inf) {
      if (length(z) < 5) return(NA_real_)
      round(sum(z[from:min(to, length(z))]) / 60, 1)
    }
    new <- new %>%
      filter(type %in% c("Run", "TrailRun", "VirtualRun")) %>%
      transmute(
        id, start = ymd_hms(start_date_local, tz = "Europe/Paris"),
        km        = round(distance / 1000, 2),
        duree_min = round(moving_time / 60, 1),
        fc_moy    = average_heartrate,
        fc_max    = max_heartrate,
        z12_min   = sapply(icu_hr_zone_times, zmin, 1, 2),
        z3_min    = sapply(icu_hr_zone_times, zmin, 3, 3),
        z4_min    = sapply(icu_hr_zone_times, zmin, 4, 4),
        z5p_min   = sapply(icu_hr_zone_times, zmin, 5),
        # share of time above HR zone 2
        frac_z3plus = {
          tot <- z12_min + z3_min + z4_min + z5p_min
          round(if_else(tot > 0, (z3_min + z4_min + z5p_min) / tot, NA_real_), 3)
        }
      ) %>%
      filter(!is.na(km))  # activities without distance (e.g. manual entries)
  }
  runs <- bind_rows(new, old) %>%
    distinct(id, .keep_all = TRUE) %>%  # overlapping day: keep fresh version
    arrange(desc(start))
  runs %>%
    mutate(start = format(start, "%Y-%m-%d %H:%M:%S")) %>%  # local Paris time, no "Z"
    readr::write_tsv(cache)
  runs
}
