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
  "tipoEntidad_cambiaria",
  "entidad_cambiaria",
  "region",
  "provincia",
  "divisa",
  "detalles",
  "instrumento",
  "tipoCartera",
  "tipoIndicador",
  "indicador",
  "componente",
  "moneda",
  "persona"
)

contenedores |>
  html_elements("ul") |>
  purrr::map(
    \(parameter_list) {
      html_elements(parameter_list, "li") |>
        html_text() |>
        stringr::str_squish() |>
        str_remove("^[a-z]\\)")
    }
  ) |>
  set_names(parametro)


