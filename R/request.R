default_send_headers <- c("Accept" = "application/json",
                          "User-Agent" = "https://github.com/Appsilon/auth0api")

build_request <- function(
  endpoint, token, params = list(),
  api_url = NULL, method = "GET", headers = NULL
) {
  request <- list(
    method = method,
    api_url = api_url,
    endpoint = endpoint,
    url = NULL,
    headers = c(
      modify_vector(default_send_headers, headers),
      "Authorization" = paste("Bearer", token)
    ),
    params = params,
    query = NULL,
    body = NULL
  )

  request <- set_endpoint(request)
  request <- set_url(request)
  request <- set_query(request)
  request <- set_body(request)
}

set_endpoint <- function(req) {
  params <- req$params
  used_params <- str_extract_all(string = req$endpoint, pattern = regex("(?<=\\{)(.*?)(?=\\})"))
  if (is.na(used_params)) {
    return(req)
  }

  req$endpoint <- glue_data(params, req$endpoint)
  req$params <- params[!names(params) %in% used_params]

  if (!nzchar(req$endpoint)) return(req)

  # No method defined, so use default
  if (grepl("^/", req$endpoint) || grepl("^http", req$endpoint)) {
    return(req)
  }

  req$method <- gsub("^([^/ ]+)\\s+.*$", "\\1", req$endpoint)
  stopifnot(req$method %in% c("GET", "POST", "PATCH", "PUT", "DELETE"))
  req$endpoint <- gsub("^[A-Z]+ ", "", req$endpoint)
  req
}

set_url <- function(req) {
  if (grepl("^https?://", req$endpoint)) {
    req$url <- URLencode(req$endpoint)
  } else {
    api_url <- req$api_url
    req$url <- URLencode(paste0(api_url, req$endpoint))
  }

  req
}

set_query <- function(req) {
  params <- req$params
  if (req$method != "GET" || length(params) == 0L) {
    return(req)
  }
  stopifnot(length(names(params)) == length(params))
  req$query <- params
  req$params <- NULL
  req
}

set_body <- function(req) {
  if (length(req$params) == 0L) return(req)
  if (req$method == "GET") {
    warning("This is a 'GET' request and unnamed parameters are being ignored.")
    return(req)
  }
  req$body <- toJSON(req$params, auto_unbox = TRUE)
  req
}

make_request <- function(req) {

  method_fun <- list("GET" = GET, "POST" = POST, "PATCH" = PATCH,
                     "PUT" = PUT, "DELETE" = DELETE)[[req$method]]
  if (is.null(method_fun)) stop("Unknown HTTP verb")

  raw <- do.call(method_fun,
                 purrr::compact(list(url = req$url, query = req$query, body = req$body,
                              add_headers(req$headers), content_type_json())))
  raw
}
