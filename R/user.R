#' Get a user endpoint
#'
#'  The endpoint: \url{https://auth0.com/docs/api/management/v2#!/Users/get_users_by_id} can be used to retrieve user details given the \code{user_id}.
#'
#' @param user_id The id of the user to retrieve
#' @param fields A comma separated list of fields to include or exclude (depending on include_fields) from the result.
#' If left empty then all fields are retrieved.
#' @param include_fields "true" if the fields specified are to be included in the result, "false" otherwise. Default is "true".
#' @param ... other \link{auth0} settings.
#' @return Response from the Auth0 API as \code{aut0_api} object.
#' @examples
#' \dontrun{
#'   get_user("google-oauth2|123123123213123123123")
#' }
#' @export
get_user <- function(user_id, fields = NULL, include_fields = NULL, ...) {
  auth0("GET /api/v2/users/{user_id}", user_id = user_id, fields = fields, include_fields = include_fields, ...)
}

#' Update a user
#'
#'  The endpoint: \url{https://auth0.com/docs/api/management/v2#!/Users/patch_users_by_id}
#'  can be used to update user details given the \code{user_id}.
#'
#' @param user_id The user_id of the user to update.
#' @param ... Parameters that should be updated in user data.
#' @return Answer from the Auth0 API as \code{aut0_api} object.
#' @examples
#' \dontrun{
#' ## Update user metadata
#' update_user("google-oauth2|123213", user_metadata = list(key = "value"))
#' ## Update user email_verified and user_metadata
#' update_user("google-oauth2|123213", user_metadata = list(key = "value"), email_verified = TRUE)
#' }
#' @export
update_user <- function(user_id, ...) {
  auth0("PATCH /api/v2/users/{user_id}", user_id = user_id, ...)
}
