
# Paquetes ----------------------------------------------------------------
library(dplyr)
library(httr)
library(jsonlite)

# Setup -------------------------------------------------------------------
key <- Sys.getenv("subban_primary")
base_url = "https://apis.sb.gob.do/estadisticas/v2"
end_point = "captaciones/moneda"

result <- httr::GET(
  url = paste(base_url, end_point, sep = "/"),
  add_headers("Ocp-Apim-Subscription-Key"= key),
  query = list(
    periodoInicial = "2019-01",
    periodoFinal = "2021-12",
    tipoEntidad= "TODOS"
  ),
  encode = "json"
)

result <- content(result, as = "text", encoding = "UTF-8")
result <- fromJSON(result)
df <- dplyr::as_tibble(result)

# Functions ---------------------------------------------------------------

#' @param tipo_entidad vector character c("AAyP", "BAyC", "BM", "CC", "EP", "TODOS")
#' @param by character string with one of these options c("moneda", "localidad", "sector")
#' @export
get_captaciones <- function(
    periodo_inicial = "2021-01",
    periodo_final = NULL,
    entidad = NULL,
    tipo_entidad = "TODOS",
    key = Sys.getenv("subban_primary"),
    by = "moneda"
) {

  base_url = "https://apis.sb.gob.do/estadisticas"

  end_point = switch (
    by,
    moneda = "captaciones/moneda",
    localidad = "captaciones/localidad",
    sector = "captaciones/sector-depositante"
  )

  # Set query
  parameters <- list(
    periodoInicial = periodo_inicial,
    periodoFinal = periodo_final,
    tipoEntidad = tipo_entidad,
    entidad = entidad
  )

  # http request
  result <- httr::GET(
    url = paste(base_url, end_point, sep = "/"),
    httr::add_headers("Ocp-Apim-Subscription-Key"= key),
    query = list(
      periodoInicial = periodo_inicial,
      periodoFinal = periodo_final,
      tipoEntidad= tipo_entidad
    ),
    encode = "json"
  )

  result <- httr::content(result, as = "text", encoding = "UTF-8") |>
    jsonlite::fromJSON()

  dplyr::as_tibble(result$data)
}


#' @param tipo_entidad vector character c("AAyP", "BAyC", "BM", "CC", "EP", "TODOS")
#' @param by character string with one of these options c("moneda", "localidad", "sector")
#' @export
get_cartera <- function(
    periodo_inicial = "2021-01",
    periodo_final = NULL,
    entidad = NULL,
    tipo_entidad = NULL,
    by = "clasificacion-riesgo",
    key = Sys.getenv("subban_primary")
) {

  base_url = "https://apis.sb.gob.do/estadisticas"

  end_point = switch (
    by,
    "clasificacion-riesgo" = "creditos/clasificacion-riesgo",
    localidad = "captaciones/localidad",
    sector = "captaciones/sector-depositante"
  )

  # Set query
  parameters <- list(
    periodoInicial = periodo_inicial,
    periodoFinal = periodo_final,
    tipoEntidad = tipo_entidad,
    entidad = entidad
  )

  # http request
  result <- httr::GET(
    url = paste(base_url, end_point, sep = "/"),
    httr::add_headers("Ocp-Apim-Subscription-Key"= key),
    query = list(
      periodoInicial = periodo_inicial,
      periodoFinal = periodo_final,
      tipoEntidad= tipo_entidad
    ),
    encode = "json"
  )

  result <- httr::content(result, as = "text", encoding = "UTF-8") |>
    jsonlite::fromJSON()

  dplyr::as_tibble(result$data)
}


