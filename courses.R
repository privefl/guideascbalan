library(dplyr)
library(lubridate)

tests_VMA <- tibble::tribble(
  ~date,      ~vitesse,
  "24/09/26", 18.5,
  "02/10/25", 17.77,
  "07/12/24", 17.5,
  "08/10/24", 17.27,
  "18/10/22", 16.0
) %>%
  mutate(course = "Test VMA") %>%
  print()

marathons <- tibble::tribble(
  ~ville,  ~date,      ~chrono,
  # "Vercors", "27/06/26", "3:26:00"
) %>%
  mutate(course = "Marathon", dist = 42.2) %>%
  print()

semis <- tibble::tribble(
  ~ville,  ~date,      ~chrono,
  "Annecy", "15/04/23", "1:43:53",
  "Dole", "13/10/24", "1:31:58",
  "Dole", "12/10/25", "1:27:36",
  "Bourg-en-Bresse", "03/03/24", "1:37:45",
  "Bourg-en-Bresse", "02/03/25", "1:29:10",
  "Bourg-en-Bresse", "01/03/26", "1:23:48"
) %>%
  mutate(course = "Semi-marathon", dist = 21.1) %>%
  print()

`10K` <- tibble::tribble(
  ~ville,      ~date,      ~chrono,
  "Troyes",     "11/05/25", "40:54",
  "Bletterans", "23/03/25", "40:44",
  "Bettant",    "05/04/26", "40:14"
) %>%
  mutate(course = "10 km", dist = 10) %>%
  print()

DHL5K <- tibble::tribble(
  ~date,      ~chrono,
  "24/08/23", "21:44",
  "22/08/24", "20:40",
  "21/08/25", "19:06"
) %>%
  mutate(course = "5K DHL Aarhus", dist = 5) %>%
  print()

extras <- tibble::tribble(
  ~date,      ~nom,
  "01/09/24", "Dagnarde 20K",
  "22/09/24", "Viaduc de Millau",
  "17/11/24", "Semi Vénissieux",
  "27/06/26", "Marathon Vercors",
  "30/08/26", "Dagnarde 20K",
  "10/10/26", "Marathon relais"
) %>%
  mutate(date = dmy(date))

objectifs <- tibble::tribble(
  ~course,         ~date,      ~chrono,   ~dist,
  "Semi-marathon", "07/03/27", "1:20:00", 21.1,
  "10 km",         "11/04/27", "36:30",   10
) %>%
  mutate(prevu = TRUE) %>%
  print()

parse_chrono <- function(x) {
  x2 <- ifelse(grepl("^\\d{1,2}:\\d{2}$", x), paste0("00:", x), x)
  hms(x2) / hours(1)
}

all <- bind_rows(tests_VMA, marathons, semis, `10K`, DHL5K, objectifs) %>%
  mutate(
    date    = dmy(date),
    course  = factor(course, c("Test VMA", "5K DHL Aarhus", "10 km", "Semi-marathon", "Marathon")),
    vitesse = ifelse(!is.na(vitesse), vitesse, dist / parse_chrono(chrono)),
    prevu   = coalesce(prevu, FALSE)
  ) %>%
  print()

# Last actual result + target, for each course that has a target
proj <- all %>%
  group_by(course) %>%
  filter(any(prevu), prevu | date == max(date[!prevu])) %>%
  ungroup()

courses <- all %>%
  filter(!prevu, course != "Test VMA", date >= dmy("01/09/24")) %>%
  mutate(nom = case_when(
    course == "Semi-marathon" ~ paste("Semi", ville),
    course == "10 km"         ~ paste("10K", ville),
    course == "Marathon"      ~ paste("Marathon", ville),
    TRUE                      ~ as.character(course)
  )) %>%
  select(date, nom) %>%
  bind_rows(extras) %>%
  distinct(date, .keep_all = TRUE)  # avoid duplicates if a race is later added to `all`
