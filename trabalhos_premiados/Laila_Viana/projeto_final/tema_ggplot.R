tema_ggplot <- function() {
  theme_classic()  +
    theme(text = element_text(family="Asul"),
        axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size = 20),
        axis.title = element_text(size = 24),
        strip.text = element_text(size = 16),
        plot.caption = element_text(size = 18))
}