library(dplyr)

# table obtenue ici: https://www.u-run.fr/85174-predire-ses-performances-avec-la-vma
vma_table <- tribble(
  ~VMA_kmh, ~`5K`,   ~`10K`,  ~semi,   ~marathon,
  07,     "00:50:54",   "01:47:36",   "04:00:58",   "09:07:51",
  10,     "00:34:37",   "01:13:12",   "02:43:56",   "06:12:43",
  13,     "00:26:05",   "00:55:08",   "02:03:29",   "04:40:45",
  16,     "00:20:50",   "00:44:04",   "01:38:40",   "03:44:21",
  19,     "00:17:19",   "00:36:36",   "01:21:58",   "03:06:21",
  22,     "00:14:47",   "00:31:14",   "01:09:57",   "02:39:03",
  25,     "00:12:52",   "00:27:13",   "01:00:56",   "02:18:33"
) %>%
  tidyr::pivot_longer(cols = -VMA_kmh, names_to = "distance",
                      values_to = "temps") %>%
  mutate(dist = case_when(
    distance == "5K" ~ 5,
    distance == "10K" ~ 10,
    distance == "semi" ~ 42.195 / 2,
    distance == "marathon" ~ 42.195
  )) %>%
  mutate(distance = factor(distance, levels = c("5K", "10K", "semi", "marathon")),
         temps_h = as.double(lubridate::hms(temps)) / 3600,
         vitesse = dist / temps_h)

library(ggplot2)
ggplot(vma_table, aes(VMA_kmh, vitesse, color = distance, group = distance)) +
  theme_bw() +
  scale_x_log10() + scale_y_log10() +
  geom_point(size = 3) +
  geom_line() +
  stat_smooth(
    method = "nls",
    formula = y ~ a + b * x,
    method.args = list(start = list(a = 0, b = 1)),
    se = FALSE,
    color = "black"
  ) +
  labs(x = "VMA (km/h)", y = "Speed (km/h)")

vma_table %>%
  summarize({
    nls(log(vitesse) ~ a + b * log(VMA_kmh),
        start = list(a = 0, b = 1)) %>%
      summary() %>%
      print() %>%
      { .$coef[, "Estimate"] } %>%
      print() %>%
      as.list() %>% as.data.frame()
  }, .by = distance)

# -0.3274194  1.0799433
# -0.3829213  1.0799415
# -0.4429081  1.0800734
# -0.5709553  1.0800011

vma_table %>%
  summarize(res = {
    nls(log(vitesse) ~ a + 1.08 * log(VMA_kmh),
        start = list(a = 0)) %>%
      summary() %>%
      print() %>%
      { .$coef[, "Estimate"] }
  }, .by = distance) %>%
  pull(res)

# -0.3275719 -0.3830789 -0.4427105 -0.5709523
