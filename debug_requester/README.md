# How to use the requester

As of right now, you can only use the bash requester to test simple `operation` and `role` combination.

```
./requester_test.sh [role] [operation]
```
This debug requester also allows you to request a resource (in this case an image). 

- The available values for the `[operation]` fields are: `image_request`, `submit`, `report`, `retrieve`.  
- The available values for the `[role]` fields are: `dev`, `moderator`, `admin`, `banned`.  

For easier testing, you can use the frontend at `https://servicecnaf.test.example:8081/`.
JWT support for this debugger is on the way (or maybe not, since you can use the frontend to test the JWT). 
