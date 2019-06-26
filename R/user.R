#' Get a user endpoint
#'
#' \url{https://auth0.com/docs/api/management/v2#!/Users/get_users_by_id}
#'  This endpoint can be used to retrieve user details given the \code{user_id}.
#'
#' @param user_id The user_id of the user to retrieve
#' @param fields A comma separated list of fields to include or exclude (depending on include_fields) from the result, empty to retrieve all fields
#' @param include_fields true if the fields specified are to be included in the result, false otherwise. Defaults to true
#' @param ... all others settings \link{auth0} settings.
#' @return Answer from the Auth0 API as \code{aut0_api} object.
#' @export
get_user <- function(user_id, fields = NULL, include_fields = NULL, ...) {
  auth0("GET /api/v2/users/{user_id}", user_id = user_id, fields = fields, include_fields = include_fields, ...)
}

#' Update a user
#'
#' \url{https://auth0.com/docs/api/management/v2#!/Users/patch_users_by_id}
#'  This endpoint can be used to retrieve user details given the \code{user_id}.
#'
#' @param user_id The user_id of the user to update.
#' @param body
#' @return Answer from the Auth0 API as \code{aut0_api} object.
#' @examples
#' \dontrun{
#' ## Update user metadata
#' update_user("google-oauth2|114255757703287184685", user_metadata = list( key = "value"))
#' ## Update user email_verified and user_metadata
#' update_user("google-oauth2|114255757703287184685", user_metadata = list( key = "value"), email_verified = TRUE)
#' }
#' @export
update_user <- function(user_id, ...) {
  auth0("PATCH /api/v2/users/{user_id}", user_id = user_id, ...)
}

