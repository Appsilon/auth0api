#' Function to get API access token
#'
#' @description To get the application token see: `https://auth0.com/docs/api/management/v2`
#' @return Auth0 API token from \code{Sys.getenv("AUTH0_API_KEY")}
#' @export
api_token <- function() {
  key <- Sys.getenv("AUTH0_API_KEY")
  if (identical(key, "")) {
    stop("Please set env var AUTH0_API_KEY with your Auth0 application token",
         call. = FALSE)
  }

  key
}

#' Function to set AUTH0_API_KEY env variable
#'
#' @param api_token The Bearer API Auth0 token
#' @export
set_token <- function(api_token) {
  Sys.setenv("AUTH0_API_KEY" = api_token)
}

#' Function to get API access token
#'
#' @description This function returns your auth0 account endpoint.
#' @return Auth0 API Endpoint domain \code{Sys.getenv("AUTH0_DOMAIN")}
#' @export
api_domain <- function() {
  domain <- Sys.getenv("AUTH0_DOMAIN")
  if (identical(domain, "")) {
    stop("Please set env var AUTH0_DOMAIN to your Auth0 endpoint",
         call. = FALSE)
  }
  domain
}

#' Function to set AUTH0_DOMAIN env variable
#'
#' @param domain Organization Auth0 domain to set.
#' @examples
#' \dontrun{
#'   set_domain("https://auth0-org-domain.aut0.com")
#' }
#' @export
set_domain <- function(domain) {
  Sys.setenv("AUTH0_DOMAIN" = domain)
}

## to process HTTP headers, i.e. combine defaults w/ user-specified headers
## in the spirit of modifyList(), except
## x and y are vectors (not lists)
## name comparison is case insensitive
## http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.2
## x will be default headers, y will be user-specified
modify_vector <- function(x, y = NULL) {
  if (length(y) == 0L) return(x)
  lnames <- function(x) tolower(names(x))
  c(x[!(lnames(x) %in% lnames(y))], y)
}

#' Generate Bearer auth token
#'
#' This function allows to generate new auth token base on client id and secret
#' If you looking for more infromation see: \url{https://auth0.com/docs/api/management/v2/tokens}
#' @param client_id The OAuth application id
#' @param client_secret The OAuth application secret
#' @param .domain By default \code{\link{api_domain}}
#' @return Auth0 Bearer token
#' @export
generate_token <- function(client_id, client_secret, .domain = api_domain()) {
  resp <-
    httr::POST(
      url = build_url(parse_url(glue("{.domain}/oauth/token"))),
      body = jsonlite::toJSON(list(
        client_id = client_id,
        client_secret = client_secret,
        audience = build_url(parse_url(glue("{.domain}/api/v2/"))),
        grant_type = "client_credentials"
      ), auto_unbox = TRUE),
      httr::add_headers(default_send_headers)
    )

  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"), simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(glue("Auth0 API request failed [{httr::status_code(resp)}]\n{parsed$error_description}"), call. = FALSE)
  }

  set_token(parsed$access_token)
  message(glue("The new token was set in the environment."))
  browser()
  parsed$access_token
}
