# File that downloads font that supports cyrillic characters on server

# Function was taken from here: 
# https://github.com/rstudio/shiny-examples/blob/master/022-unicode-chinese/global.R

options(shiny.usecairo = FALSE)

font_home <- function(path = '') file.path('~', '.fonts', path)
if (Sys.info()[['sysname']] == 'Linux' &&
    system('locate deja_vu_sans.ttf') != 0 &&
    !file.exists(font_home('deja_vu_sans.ttf'))) {
  if (!file.exists('deja_vu_sans.ttf'))
    shiny:::download(
      'https://github.com/zhitkovk/Russia_in_colour/blob/master/font/deja_vu_sans.ttf',
      'deja_vu_sans.ttf'
    )
  dir.create(font_home())
  file.copy('deja_vu_sans.ttf', font_home())
  system2('fc-cache', paste('-f', font_home()))
}

rm(font_home)