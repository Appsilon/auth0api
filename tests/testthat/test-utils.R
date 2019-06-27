context("utils")

test_that(
  "Test api_token function", {
    #Given
    Sys.unsetenv("AUTH0_API_KEY")
    token = "hshdjshakjdhsakjda"
    # Then
    expect_error(api_token(), "Please set env var AUTH0_API_KEY with your Auth0 application token")
    # When
    set_token(token)
    # Then
    expect_identical(api_token(), token)
  }
)

test_that(
  "Test api_domain function", {
    #Given
    Sys.unsetenv("AUTH0_DOMAIN")
    domain = "accountname.us.auth0.com"
    # Then
    expect_error(api_domain(), "Please set env var AUTH0_DOMAIN to your Auth0 endpoint")
    # When
    set_domain(domain)
    # Then
    expect_identical(api_domain(), domain)
  }
)

test_that(
  "Test modify_vector", {
    # Given
    vector1 = c(a = "a", b = "b", c = "c", d = 4)
    vector2 = c(a = "b", c = "d", e = 4)
    # Then
    expect_equal(modify_vector(vector1,vector2), c(b = "b", d = 4, a = "b", c = "d", e = 4))
    expect_equal(modify_vector(vector2,vector1), c(e = 4, a = "a", b = "b", c = "c", d = 4))
  }
)
