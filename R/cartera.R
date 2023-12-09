
#' @param tipo_entidad vector character c("AAyP", "BAyC", "BM", "CC", "EP",
#'  "TODOS")
#' @param by character string with one of these options c("moneda",
#' "localidad", "sector")
#' @export
get_cartera <- function(
    periodo_inicial = "2023-01",
    periodo_final = NULL,
    entidad = "popular",
    tipo_entidad = NULL,
    by = NULL,
    key = Sys.getenv("subban_primary")
) {
  endpoint <- "carteras/creditos"

  if (!is.null(by)) {
    checkmate::check_choice(
      by,
      c("genero", "clasificacion-riesgo", "localidad", "moneda",
        "sectores-economicos", "tipo", "facilidad", "inversiones")
    )

    endpoint <- paste(endpoint, by, sep = "/")
  }

  base_url <- "https://apis.sb.gob.do/estadisticas/v2"

  # Set query
  parameters <- list(
    periodoInicial = periodo_inicial,
    periodoFinal = periodo_final,
    tipoEntidad = tipo_entidad,
    entidad = entidad
  )

  # http request
  result <- httr::GET(
    url = paste(base_url, endpoint, sep = "/"),
    httr::add_headers("Ocp-Apim-Subscription-Key" = key),
    query = parameters,
    encode = "json"
  )

  result <- httr::content(result, as = "text", encoding = "UTF-8") |>
    jsonlite::fromJSON()

  dplyr::as_tibble(result)
}
