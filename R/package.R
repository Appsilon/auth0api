#' Aut0 API Client
#'
#' Minimal wrapper to access Auth0 API.
#'
#' @docType package
#' @import glue
#' @import httr
#' @importFrom purrr compact
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite fromJSON
#' @importFrom stringr regex
#' @importFrom stringr str_extract_all
#' @importFrom utils URLencode
#' @name auth0api
NULL


#' Query the Auth0 Managment API
#'
#' This is an extremely minimal client. You need to know the Auth0 API
#' to query Auth0 endpoint.
#' \itemize{
#'   \item Tries to substitute each listed parameter into
#'     \code{endpoint}, using the \code{{param}} notation.
#'     Replaced \code{{param}} will be parsed with \code{glue} package using provided \code{...} parameters.
#'   \item If a GET request is chosen (the default), then adds
#'     all other listed parameters as query parameters.
#'   \item If not a GET request, then sends the other parameters
#'     in the request body as JSON.
#'   \item The response is converted to an R list using
#'     \code{jsonlite::fromJSON}.
#' }
#'
#' @param endpoint Auth0 API endpoint. Must be one of the following forms:
#'
#'    \itemize{
#'      \item "METHOD path", e.g. "GET /api/v2/users/{id}"
#'      \item "path", e.g. "/api/v2/users/{id}".
#'      \item "METHOD url", e.g. "GET https://auth0-org-domain.auth0.com/api/v2/users/{id}"
#'      \item "url", e.g. "https://auth0-org-domain.aut0.com/api/v2/users/{id}".
#'    }
#'
#'    If the method is not supplied, \code{.method} parameter is used (\code{GET} by default).
#' @param ... Name-value pairs giving API parameters. Will be matched
#'   into \code{url} placeholders, sent as query parameters in \code{GET}
#'   requests, and in the JSON body of \code{POST} requests.
#' @param .auth_key Authentication token. Sourced by default with \link{api_token}
#' @param .domain Auth0 API domain (default: \link{api_domain}).
#'   Used if \code{endpoint}  contains a path only.
#' @param .method HTTP method to use if not explicitly supplied in the
#'    \code{endpoint}.
#' @param .headers Named character vector of header field values
#'   (except \code{Authorization}, which is handled via
#'   \code{.token}). This can be used to override or augment the
#'   defaults, which are as follows: the \code{Accept} field set up
#'   to \code{"application/json"} by default and the
#'   \code{User-Agent} field \code{"https://github.com/Appsilon/auth0-api"} - default.
#'   This can be used, e.g. to provide a custom headers for special needs.
#' @return Response from the Auth0 API as \code{aut0_api} object
#' @examples
#' \dontrun{
#' ## Get user data from Auth0 Endpoint
#' auth0("GET /api/v2/users/{id}", id = "auth0|userid")
#' auth0("GET /api/v2/users/{id}", id = "auth0|userid", field = "nickname", include_fields = "false")
#' }
#' @export
auth0 <- function(endpoint, ..., .domain = NULL, .auth_key = api_token(), .method = "GET", .headers = NULL) {
  if(missing(.domain) && !grepl("^http", endpoint)) .domain <- api_domain()

  req <- build_request(
    endpoint,
    token = .auth_key,
    api_url = .domain,
    method = .method,
    headers = .headers,
    params = list(...)
  )

  resp <- make_request(req)
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Auth0 API request failed [%s]\n%s\n<%s>",
        httr::status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  structure(
    list(
      content = parsed,
      endpoint = endpoint,
      response = resp
    ),
    class = "aut0_api"
  )
}

print.aut0_api <- function(x, ...) {
  print(x$content, ...)
}
