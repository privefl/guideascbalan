df <- bigreadr::fread2("Activities.csv")
table(df$`Type d'activité`)
library(dplyr)
df_running <- filter(df, `Type d'activité` == "Course à pied")
table(df_running$`Training Stress Score® (TSS®)`)  # all 0
filter(df_running, Distance < 1)

library(ggplot2)
theme_set(theme_bw())
ggplot(df_running, aes(lubridate::ymd_hms(Date), `Cadence moyenne`)) +
  geom_point()

plot(table(as.integer(df_running$`Fréquence cardiaque maximale`)))
plot(table(as.integer(df_running$`Fréquence cardiaque moyenne`)))

ggplot(df_running, aes(lubridate::ymd_hms(Date),
                       as.integer(`Fréquence cardiaque maximale`))) +
  geom_point()


# install.packages("slider")

df_prepare <- df_running %>%
  # 1. On convertit la date correctement
  mutate(Date = lubridate::ymd_hms(Date) %>% as.Date(),
         FCmax = as.integer(`Fréquence cardiaque maximale`)) %>%
  # 2. On s'assure que tout est dans l'ordre chronologique
  arrange(Date) %>%
  # 3. Calcul de la somme glissante sur 7 jours
  mutate(
    Distance_7j = slider::slide_index_dbl(
      .x = Distance,         # La colonne à additionner
      .i = Date,             # La colonne de temps de référence
      .f = sum,              # La fonction mathématique (somme)
      .before = lubridate::days(6)      # La fenêtre : 6 jours avant + le jour J = 7 jours
    )
  ) %>%
  print()

df_prepare %>%
  filter(!is.na(FCmax)) %>%
  ggplot(aes(Date, FCmax, color = cut(FCmax, c(0, 150, 165, 200)))) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(color = "FC max")

# 4. Le graphique (une ligne est souvent plus lisible pour des cumuls)
df_prepare %>%
  filter(Date > min(Date) + lubridate::days(6)) %>%
  ggplot(aes(x = Date, y = Distance_7j)) +
  geom_area(fill = "lightblue", alpha = 0.5) + # Optionnel : remplit sous la courbe
  geom_line(color = "blue") +
  labs(
    title = "Charge d'entraînement",
    y = "Distance cumulée sur 7 jours (km)",
    x = "Date"
  ) +
  geom_smooth(color = "orange", linetype = 2, se = FALSE) +
  theme_minimal()
