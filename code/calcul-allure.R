library(dplyr)

# table obtenue ici: https://www.u-run.fr/85174-predire-ses-performances-avec-la-vma
vma_table <- tribble(
  ~VMA_kmh, ~`5K`,   ~`10K`,  ~semi,   ~marathon,
  12.0,     0.806,   0.697,   0.658,   0.516,
  12.5,     0.814,   0.713,   0.674,   0.539,
  13.0,     0.824,   0.733,   0.694,   0.570,
  13.5,     0.839,   0.747,   0.708,   0.586,
  14.0,     0.857,   0.765,   0.726,   0.615,
  14.5,     0.862,   0.773,   0.738,   0.634,
  15.0,     0.870,   0.784,   0.753,   0.657,
  15.5,     0.880,   0.798,   0.762,   0.672,
  16.0,     0.893,   0.815,   0.773,   0.691,
  16.5,     0.887,   0.822,   0.785,   0.706,
  17.0,     0.882,   0.830,   0.799,   0.720,
  17.5,     0.891,   0.838,   0.808,   0.734,
  18.0,     0.901,   0.847,   0.819,   0.748,
  18.5,     0.905,   0.855,   0.827,   0.760,
  19.0,     0.911,   0.865,   0.837,   0.776,
  19.5,     0.914,   0.873,   0.843,   0.785,
  20.0,     0.918,   0.882,   0.851,   0.796,
  20.5,     0.924,   0.887,   0.854,   0.805,
  21.0,     0.932,   0.893,   0.859,   0.814,
  21.5,     0.936,   0.896,   0.865,   0.823,
  22.0,     0.936,   0.900,   0.872,   0.834,
  22.5,     0.939,   0.911,   0.877,   0.845,
  23.0,     0.943,   0.914,   0.883,   0.853
) %>%
  tidyr::pivot_longer(cols = -VMA_kmh, names_to = "distance",
                      values_to = "fraction_of_VMA") %>%
  mutate(distance = factor(distance, levels = c("5K", "10K", "semi", "marathon")))

library(ggplot2)
ggplot(vma_table, aes(VMA_kmh, fraction_of_VMA, color = distance, group = distance)) +
  theme_bw() +
  geom_point() +
  geom_line() +
  stat_smooth(
    method = "nls",
    formula = y ~ c - a * exp(-b * x),
    method.args = list(start = list(a = 1, b = 0.12, c = 1)),
    se = FALSE,
    color = "black"
  ) +
  xlim(10, 25) +
  # geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black", se = FALSE) +
  labs(x = "VMA (km/h)", y = "Fraction of VMA")



vma_table %>%
  summarize({
    nls(fraction_of_VMA ~ c - a * exp(-b * VMA_kmh),
        start = list(a = 1, b = 0.1, c = 1)) %>%
      summary() %>%
      { .$coef[, "Estimate"] } %>%
      print() %>%
      as.list() %>% as.data.frame()
  }, .by = distance)


#       a      b      c
# 5K:   0.9706 0.1471 0.9729
# 10K:  1.2519 0.1211 0.9904
# semi: 1.3875 0.1279 0.9558
# mara: 1.9021 0.1187 0.9739

ggplot(vma_table, aes(VMA_kmh, fraction_of_VMA * VMA_kmh, color = distance, group = distance)) +
  theme_bw() +
  geom_point() +
  geom_line() +
  stat_smooth(
    method = "nls",
    formula = y ~ a + b * x,
    method.args = list(start = list(a = 0, b = 1)),
    se = FALSE,
    color = "black"
  ) +
  xlim(10, 25) +
  # geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black", se = FALSE) +
  labs(x = "VMA (km/h)", y = "Speed (km/h)")

vma_table %>%
  summarize({
    nls(I(fraction_of_VMA * VMA_kmh) ~ a + b * VMA_kmh,
        start = list(a = 0, b = 1)) %>%
      summary() %>%
      { .$coef[, "Estimate"] } %>%
      print() %>%
      as.list() %>% as.data.frame()
  }, .by = distance)

# -3.338833  1.087887
# -5.466186  1.152099
# -5.698478  1.132304
# -8.488501  1.220164


vma_table %>%
  mutate(dist = case_when(
    distance == "5K" ~ 5,
    distance == "10K" ~ 10,
    distance == "semi" ~ 42.195 / 2,
    distance == "marathon" ~ 42.195
  )) %>%
  nls(I(fraction_of_VMA * VMA_kmh) ~ a1 * log(dist) + a2 + (b1 * log(dist) + b2) * VMA_kmh, data = .,
      start = list(a1 = 0, a2 = 0, b1 = 1, b2 = 0))

plot(c(-3.34, -5.47, -5.70, -8.49))
plot(c(1.09, 1.15, 1.13, 1.22))

vma_table %>%
  mutate(dist = case_when(
    distance == "5K" ~ 5,
    distance == "10K" ~ 10,
    distance == "semi" ~ 42.195 / 2,
    distance == "marathon" ~ 42.195
  )) %>%
  ggplot(aes(VMA_kmh, fraction_of_VMA * VMA_kmh, color = distance, group = distance)) +
  theme_bw() +
  geom_point() +
  geom_line() +
  stat_smooth(
    method = "nls",
    formula = y ~ a + b * x,
    method.args = list(start = list(a = 0, b = 1)),
    se = FALSE,
    color = "black"
  ) +
  xlim(10, 25) +
  # geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black", se = FALSE) +
  labs(x = "VMA (km/h)", y = "Speed (km/h)")

