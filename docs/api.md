# API

There are optional API routes that can be enabled by setting the constant [ENABLE_API](../config/initializers/0_constants.rb) to `true` which will enable the API within your application.

We use [Pundit](https://github.com/varvet/pundit) to authorize access to our API endpoints. We use [Blueprinter](https://github.com/procore/blueprinter) to easily present our json object in the API response.

## Authentication

For authentication, we use [JWT](https://github.com/jwt/ruby-jwt) to generate authorization tokens and we also have a model [ApiKey](../app/models/api_key.rb) to generate an API key.

All endpoints require the API key to be passed as a header like `x-api-key: xxx`.

The [Api::V1::Auth::AuthController](../app/controllers/api/v1/auth/auth_controller.rb) takes care of **Sign in** by generating a **JWT token** when a valid `email` and `password` are passed as params along with the API key. Signing in also requires that the **User** record is confirmed.

For **confirming an email** or to **request a password reset link**, a valid response requires an `email` to passed in as a param.

For most the other endpoints, in addition to the API key, we would pass in the **JWT token** as an authorization header like `Authorization: "Bearer <JWT token here>"`.

Once authenticated, you can access the signed in **User's** record by calling [current_user](../app/controllers/api/v1/base_controller.rb).

## Pagination

We have a method [paginated_collection()](../app/controllers/api/v1/base_controller.rb) that takes in a **collection of records**, the **blueprint** to use and the blueprinter **view** to use and returns an API response in the form of a neatly organized list with pagination data included.

## Error Codes

The method [handle\_api_error](../app/controllers/api/v1/base_controller.rb) takes care of rendering the error responses.

1. Unauthorized - Happens when API key/token is invalid or if the user is not authorized(pundit) to access the endpoint.
2. Forbidden - This error will not be thrown for the most part. It is only thrown if there is no record to check for authorization(pundit).
3. Unprocessable Entity - This error is thrown if an unconfirmed user tries to sign in or if an API call to update a user record fails. A detailed message with the error is also provided.
4. Internal Server Error - This type of error is due to some method breaking and is not desired. It should be handled gracefully if observed.

The methods for rendering the above errors can be found in the [BaseController](../app/controllers/api/v1/base_controller.rb). They can be passed a message to be rendered along with the error response.