# Service server 

This service server is used to provide the both the application frontend for testing, and to receive requests towards protected api routes.
The protected route in question is `/operation/`, so every request that goes to that path will be redirected to OPA first, using NGINX's `auth_request` directive.
