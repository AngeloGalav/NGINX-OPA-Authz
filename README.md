# Using OPA as an auth server with NGINX
Proof of concept for using OpenPolicyAgent as an _Authorization_ server.
This configuration uses NGINX as both the service server and reverse proxy, and uses NGINX's `auth_request` directive in order to pass the authorization request to OPA.

Includes SSL support using dummy certs from CNAF.

You can find another implementation of the proposed PoC using a sidecar [here](https://github.com/AngeloGalav/NGINX-OPA-Authz/tree/sidecar_version).

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

1. The user makes a request through the frontend/debug_requester. **BEWARE**: the user must already be authenticated.  
2. NGINX reverse proxy processes the request, and sends it to OPA
3. OPA makes a decision using its rules and data, and sends it to the Reverse Proxy
4. NGINX then receives the data coming from OPA and processes it:
        * If `allow != true`, then NGINX forbids the request to continue further, and sends code 403 to the requesting user.
        * Else, if `allow == true`, NGINX forwards the request to the Service Server. 
5. (and 6) If the Service Server returns a response, it goes through the Reverse Proxy and gets returned to the server. 


## How to use
You can use the following commands in order to start the Docker containers
```bash
sudo docker-compose up
```
You can access the frontend of this project (and test it) by connecting to `https://pippocnaf.test.example:8081/` with a web browser.

## SSL Disclaimer
Since the service uses dummy certificates made for testing, your browser may tell you that a certificate may be invalid/the CA cannot be trusted. 
This is normal and caused by the igi-ca certificates which are, in fact, made for testing purposes only. 

## Some useful resources
- [auth_request explanation](https://redbyte.eu/en/blog/using-the-nginx-auth-request-module/)
- [Similar Github repository](https://github.com/summerwind/opa-nginx-rbac)
