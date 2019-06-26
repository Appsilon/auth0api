#' Function to get API access token
#'
#' @description To get the application token check: `https://auth0.com/docs/api/management/v2`
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
