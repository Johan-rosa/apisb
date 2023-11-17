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

parametro_name <- c(
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

detalles <- contenedores |>
  html_elements("ul") |>
  purrr::map(
    \(parameter_list) {
      html_elements(parameter_list, "li") |>
        html_text() |>
        str_remove("^[a-z]\\)")  |>
        stringr::str_squish()
    }
  ) |>
  set_names(parametro)

string_to_df <- function(string) {
  dplyr::tibble(string = string) |>
    tidyr::separate(string, into = c("id", "label"), sep = " = ")
}

detalles <- detalles |>
  purrr::imap(
    \(detalles, name) {
      if (stringr::str_detect(name, "[eE]ntidad")) return(string_to_df(detalles))
      detalles
    }
  )

usethis::use_data(detalles, overwrite = TRUE)
