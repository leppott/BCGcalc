# Create Sticker
#
# Erik.Leppo@tetratech.com
# 2021-04-04
#
# https://github.com/GuangchuangYu/hexSticker
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# COLOR ----
# image
img <- file.path(file.path("data-raw", "BCG_figure.png"))

# sticker
sticker(img
        , package = "BCGcalc"
        , p_size = 20
        , s_x = 1
        , s_y = .75
        , s_width = .55
        , filename = "inst/figures/logo.png")

# BLACK and WHITE ----
# image
img <- file.path(file.path("data-raw", "BCG_figure_bw.png"))

# sticker
sticker(img
        , package = "BCGcalc"
        , p_size = 20
        , s_x = 1
        , s_y = .75
        , s_width = .55
        , filename = "inst/figures/logo_bw.png")