library(rvest)
library(dplyr)
library(stringr)
library(purrr)

url_parametros <- "https://desarrollador.sb.gob.do/referencias#uk1jx"

contenedores <- read_html(url_parametros) |>
  html_elements("div.ProseMirror")

contenedores <- contenedores[-c(1, 2)]

descripcion_parametros <- contenedores |>
  html_elements("h1") |>
  html_text()

parametro <- c(
  "tipoEntidad",
  "entidad",
  "persona",
  "instrumento",
  "divisa"

)

contenedores |>
  html_elements("ul") |>
  purrr::map(
    \(parameter_list) {
      html_elements(parameter_list, "li") |>
        html_text()
    }
  )


