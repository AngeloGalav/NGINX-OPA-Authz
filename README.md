# Using OPA as an auth server with NGINX
Proof of concept for using OpenPolicyAgent as an Authorization server.
This configuration uses NGINX as both the service server and reverse proxy, and uses NGINX's `auth_request` directive in order to pass the authorization request to OPA's sidecar.

## Architecture
This scheme follows a simple user request using our system

```
                      |
                      |
                      |                       +---------+
                      |             +-------->| OPA     |
                      |             |         | Sidecar |
                      |             | +-------+         |
                      |             | |       +---------+
                      |             | |       +---------+------+
                      |             | |       |                |
                      |             | |       | OPA Authz      |
                      |             | |       | Server         |
                      |             | |       |                |
              +-------+----+        | |       +----------------+
              |            |   2    | |
     1        |  Reverse   +--------+ |
------------->|  Proxy     |          |3
              |            |<---------+
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
You'll then need to access the page at `localhost:8081` in order to test the frontend. 


## Some useful resources
- [auth_request explanation](https://redbyte.eu/en/blog/using-the-nginx-auth-request-module/)
- [Similar Github repository](https://github.com/summerwind/opa-nginx-rbac)
- [Why we can't use body/POST in auth_request](https://stackoverflow.com/questions/40645270/nginx-auth-request-handler-accessing-post-request-body)
- [Why we can't use variables in auth_request](https://stackoverflow.com/questions/60989302/how-do-you-send-an-auth-request-to-a-variable-uri-in-nginx)
