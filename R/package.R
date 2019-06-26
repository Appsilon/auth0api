
#' Aut0 API Client
#'
#' Minimal wrapper to access Auth0 API.
#'
#' @docType package
#' @name auth0api
NULL


#' Query the Auth0 Managment API
#'
#' This is an extremely minimal client. You need to know the API
#' to query Auth0 endpoint.
#' \itemize{
#'   \item Try to substitute each listed parameter into
#'     \code{endpoint}, using the \code{{param}} notation. It using glue package.
#'   \item If a GET request (the default), then add
#'     all other listed parameters as query parameters.
#'   \item If not a GET request, then send the other parameters
#'     in the request body, as JSON.
#'   \item Convert the response to an R list using
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
#'    If the method is not supplied, will use \code{.method}, which defaults
#'    to \code{GET}.
#' @param ... Name-value pairs giving API parameters. Will be matched
#'   into \code{url} placeholders, sent as query parameters in \code{GET}
#'   requests, and in the JSON body of \code{POST} requests.
#' @param .auth_key Authentication token. by default \link{api_token}
#' @param .api_url Auth0 API domain (default: \link{api_domain}).
#'   Used if \code{endpoint} just contains a path.
#' @param .method HTTP method to use if not explicitly supplied in the
#'    \code{endpoint}.
#' @param .headers Named character vector of header field values
#'   (excepting \code{Authorization}, which is handled via
#'   \code{.token}). This can be used to override or augment the
#'   defaults, which are as follows: the \code{Accept} field defaults
#'   to \code{"application/json"} and the
#'   \code{User-Agent} field defaults to
#'   \code{"https://github.com/Appsilon/auth0api"}. This can be used
#'   to, e.g., provide a custom headers for special needs.
#' @return Answer from the Auth0 API as \code{aut0_api} object
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
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  if (http_error(resp)) {
    stop(
      sprintf(
        "Auth0 API request failed [%s]\n%s\n<%s>",
        status_code(resp),
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

aut0_api.print <- function(x, ...) {
  print(x$content, ...)
}
