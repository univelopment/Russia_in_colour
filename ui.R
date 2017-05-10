# App interface
source("libraries.R")

shinyUI(navbarPage("Карта России в цвете",
                   theme = shinythemes::shinytheme("simplex"),
                   tabPanel(
                     "Пример",
                     sidebarLayout(
                       sidebarPanel(
                         
                         # Inputs
                         selectInput(
                           "data_selector",
                           label = h4("Выберите данные:"),
                           choices = list("Зачислено на заочное" = "n_adm_external.1",
                                          "Зачислено на очное" = "n_adm_daily.1",
                                          "Зачислено на вечернее" = "n_adm_evening.1",
                                          "Доля зачисленных заочных студентов" = "n_adm_f_external.1",
                                          "Доля зачисленных очных студентов" = "n_adm_f_daily.1",
                                          "Доля зачисленных вечерних студентов" = "n_adm_f_evening.1",
                                          "Доля заочного в приеме менеджеров" = "n_adm_f_external_manager.1",
                                          "Доля заочного в приеме экономистов" = "n_adm_f_external_economics.1",
                                          "Доля заочного в приеме юристов" = "n_adm_f_external_law.1",
                                          "Доля заочного в приеме гос. управленцев" = "n_adm_f_external_public.1",
                                          "Доля заочного в приеме на управление персоналом" = "n_adm_f_external_hr.1"),
                           size = 11,
                           selectize = FALSE,
                           selected = "n_adm_f_external.1"),
                         
                         selectInput(
                           "pal",
                           label = h4("Выберите цветовую схему:"),
                           choices = list("Синий-зеленый" = "BuGn",
                                          "Синий-сиреневый" = "BuPu",
                                          "Зеленый-синий" = "GnBu",
                                          "Сиреневый-красный" = "PuRd",
                                          "Желтый-зеленый" = "YlGn",
                                          "Желтый-зеленый-синий" = "YlGnBu",
                                          "Желтый-оранжевый-красный" = "YlOrRd"),
                           selectize = TRUE,
                           selected = "YlGnBu"
                         ),
                         
                         # Text info
                         textInput(
                           "text_title", label = h4("Название графика"), value = "Регионы России"
                           ),
                         
                         textInput(
                           "text_legend", label = h4("Название легенды"), value = "Доля:"
                           ),
                         
                         # Download image
                         h4(
                           "Скачать изображение"
                         ),
                         
                         downloadButton(
                           "downloadPNG", "PNG"
                           ),
                         
                         downloadButton(
                           "downloadEPS", "EPS"
                         )
                         ),
                       
                       mainPanel(
                         h2("Карта России в цвете — приложение для раскраски российских регионов на основе вашей статистики."),
                         h4("Примеры того, что можно построить показаны на этой странице. На вкладке «Построить карту» можно загрузить свои данные и настроить итоговую визуализацию более точно."),
                         plotOutput("myplot")
                         )
                       )
                     ),
                   tabPanel("Построить карту",
                            sidebarLayout(
                              sidebarPanel(
                                
                                # Upload block
                                h4(
                                  "Загрузите собственные данные"
                                ),
                                
                                h5("Файл должен быть в формате xlsx и содержать минимум 2 колонки: названия регионов и интересующий
                                         вас показатель. Важно, чтобы названия регионов соответствовали образцу, 
                                         представленному по", a("ссылке", href = "https://github.com/univelopment/Russia_in_colour/blob/master/data/region_list.xlsx?raw=true", target="_blank",
                                                                rel="noopener noreferrer"), ".", "К примеру, фраза \"г. Москва\"
                                         должна содержать пробел после \"г.\"."
                                ),
                                
                                fileInput(
                                  "fileUpload_y",
                                  label = h5("Добавьте ваш файл:"),
                                  accept = c(".xlsx")
                                ),
                                
                                # Variable selection
                                h4("Выбор колонок"),
                                
                                selectInput(
                                  "reg_select",
                                  label = h5("Выберите столбец с названиями регионов:"),
                                  ""
                                ),
                                
                                selectInput(
                                  "var_select",
                                  label = h5("Укажите столбец со значениями показателя:"),
                                  ""
                                ),
                                
                                # Colors and scales
                                h4("Палитра цветов для карты"),
                                
                                selectInput(
                                  "pal_y",
                                  label = h5("Выберите цветовую схему:"),
                                  choices = list("Синий-зеленый" = "BuGn",
                                                 "Синий-сиреневый" = "BuPu",
                                                 "Зеленый-синий" = "GnBu",
                                                 "Сиреневый-красный" = "PuRd",
                                                 "Желтый-зеленый" = "YlGn",
                                                 "Желтый-зеленый-синий" = "YlGnBu",
                                                 "Желтый-оранжевый-красный" = "YlOrRd"),
                                  selectize = TRUE,
                                  selected = "YlGnBu"
                                ),
                                
                                h5(tags$p("По умолчанию значения переменной кодируются в легенде с помощью интервалов.
                                   Если вы хотите, чтобы цвет на карте обозначал конкретное значение переменной,
                                   а не интервал, то снимите галочку снизу."), 
                                   tags$p(tags$b("Пример:"), " ваша переменная принимает значения
                                   1, 2 и 3. Если снять галочку, то именно они и появятся в легенде, если же пропустить
                                   этот шаг, в легенде появятся интервалы [1;2) и [2;3].")
                                ),
                                
                                checkboxInput(
                                  "contScale",
                                  "Интервальное кодирование переменной", 
                                  value = TRUE
                                ),
                                
                                conditionalPanel(condition = "input.contScale",
                                                 selectInput(
                                                   "pal_q_y",
                                                   label = h5("Выберите число градаций цвета"),
                                                   choices = list("2" = 0.5,
                                                                  "4" = 0.25,
                                                                  "5" = 0.2),
                                                   selectize = TRUE,
                                                   selected = 0.2
                                                 ),
                                                 checkboxInput(
                                                   "tilda", 
                                                   "Использовать простую запись интервалов. Пример: 17-20 вместо [17;20)"
                                                 )
                                                 ),
                                
                                # Text info
                                h4("Подписи графика"),
                                
                                textInput(
                                  "text_title_y", 
                                  label = h5("Название вашего графика:"), 
                                  value = "Регионы России"
                                ),
                                
                                textInput(
                                  "text_legend_y", 
                                  label = h5("Заголовок легенды:"), 
                                  value = "Доля:"
                                ),
                                
                                # Plot and download image
                                actionButton(
                                  "plot_map", "Построить карту"
                                ),
                                
                                h4(
                                  "Скачать изображение"
                                ),
                                
                                downloadButton(
                                  "downloadPNG_y", "PNG"
                                ),
                                
                                downloadButton(
                                  "downloadEPS_y", "EPS"
                                )
                              ),
                              mainPanel(
                                plotOutput("myplot_y")
                                )
                              )
                            ),
                   tabPanel("О проекте",
                            includeMarkdown("description.md")
                            )
                   )
        )

