const http = require('http');
const axios = require('axios');
const { send } = require('process');

const requestListener = function (req, res) {
    // console.log(req);

    // normalmente ci basta solo passare l'operazione + token, ma siccome
    // è una demo ho passato un casino di roba in più, giusto per esplorare le possibilità
    
    let operation_ = () => {
        let words = ((req.headers["x-original-uri"]).split('/'));
        return words[words.length - 1]
    }
        
    
    let send2opa = {
        "http_method" : req.headers["x-original-method"],
        "role" : "/" + req.headers["x-role"],
        "operation" : operation_(),
        "uses_jwt" : req.headers["x-enablejwt"],
        "token" : req.headers.authorization
    }

    console.log(send2opa);


    // invia i dati ad opa
    axios.post('http://opa:8181/', send2opa)
      .then(function (opa_response) {

        console.log(opa_response.data)

        if (opa_response.data.allow === true) {
            console.log("-----DEBUG: OPA GRANTED ACCESS ");
            res.statusCode = 200;
            res.end("access granted");
        } else {
            console.log("-----DEBUG: OPA DENIED ACCESS ");
            res.statusCode = 403;
            res.end("access denied");
        }
    })
}

const server = http.createServer(requestListener);
server.listen(8080);