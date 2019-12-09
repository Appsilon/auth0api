# auth0api
The `auth0api` library is a minimalistic Auth0 management API client in R.


# Installation #

Using the 'devtools' package:

    > install.packages("devtools")
    > devtools::install_github("Appsilon/auth0-api")

# CRAN
This package is still in the development phase and it has not been published on CRAN yet.

# Usage
All endpoints are described in the [Auth0 Managment API documentation](https://auth0.com/docs/api/management/v2/).
To generate the API token see [auth0 tokens documentattion](https://auth0.com/docs/api/management/v2/tokens) or `auth0api::generate_token` function documentation.

To use the API you need to set a domain and API token.

### API token & domain

The token by default is read from an environment variable or can be passed as a param to the `auth0` function.
```
# Set domain
set_domain("https://auth0-org-domain.aut0.com")
Sys.setenv(AUTH0_DOMAIN="organization-domain")
# Set the token
set_token("api-key")
Sys.setenv(AUTH0_API_KEY="api-key")
```

### Custom endpoint
The API is minimalistic and you can easily access all endpoints in Auth0 Managment API.
```
auth0(endpoint, ..., .domain = NULL, .auth_key = api_token())
```
Use any endpoint from Auth0 API e.g. `GET /api/v2/roles/{id}`. The strings are interpolated using the glue library and as a paramaters of function use variable in brackets. See [glue](https://github.com/tidyverse/glue) for more information.
```
auth0("GET /api/v2/users/{id}", id = "auth0|userid")
```

### Predefined API endpoind:

The package contains predefined function allows to access the Auth0 API.
```
get_user("google-oauth2|1231231")
```

---
More help can be found in the package docs.
For more information please contact forys@wit.edu.pl

---
*Package development roadmap*

- [ ] Add more tests :rocket:
- [ ] Improve error message e.g. returns `Unauthorized`
- [ ] Add CI check to the repository
- [ ] Add verbose and debug options
- [ ] Improve documentation
- [ ] Create more predefined functions
- [ ] ...
