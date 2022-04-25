# Using OPA as an auth server with NGINX
Proof of concept for using OpenPolicyAgent as an Authorization server.
This configuration uses NGINX as both the service server and reverse proxy, and uses NGINX's `auth_request` directive in order to pass the authorization request to OPA.

## Architecture
This scheme follows a simple user request using our system

```
                      |
                      |                       +------------------+
                      |                       |                  |
                      |                       |  OPA Authz       |
                      |             +---------+  Server          |
                      |             |         |                  |
                      |             | +-------+                  |
              +-------+----+        | |       +------------------+
              |            |   2    | |
     1        |  Reverse   +--------+ |
------------->|  Proxy     |          |3
              |            +----------+
<-------------+            |
      6       |            +--------------------+
              +--------+---+         4          |
                       |  ^                     |
                       |  |                     v
                       |  |                    +----------------+
                       |  |        5           |                |
                       |  +--------------------+  Service       |
                       |                       |  Server        |
                       |                       |                |
                       |                       +----------------+
                       |
                       |
```

## How to use
You can use the following commands in order to start the Docker containers
```bash
sudo docker-compose up
```
You can access the frontend of this project (and test it) by connecting to `localhost:8081` with a web browser.

## Some useful resources
- [auth_request explanation](https://redbyte.eu/en/blog/using-the-nginx-auth-request-module/)
- [Similar Github repository](https://github.com/summerwind/opa-nginx-rbac)
