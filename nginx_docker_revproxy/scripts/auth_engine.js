function authorize_operation(r) {

    // dati da inviare a OPA
    let opa_data = {
        "operation" : r.headersIn["X-Operation"],
        "role" : "/" + r.headersIn["X-Role"],
        "uses_jwt" : r.headersIn["X-EnableJWT"],
        "token" : r.headersIn["Authorization"]
    }

    // pacchetto HTTP da inviare ad OPA, in modo che possa leggere correttamente i dati
    var opts = {
        method: "POST",
        body: JSON.stringify(opa_data)
    };
    
    // gestisce la risposta di OPA
    r.subrequest("/_opa", opts, function(opa_res) {
        r.log("OPA Responded with status " + opa_res.status);
        r.log(JSON.stringify(opa_res));

        var body = JSON.parse(opa_res.responseText);
        // controlla la risposta di OPA (che è in JSON)
        if (!body) {
            r.return(403);
            return;
        }

        if (!body.allow) {  // se il campo allow non c'è o è uguale a false, 
            r.return(403);  // allora ritorna forbidden (403)
            return;
        }

        r.return(opa_res.status); // Altrimenti, ritorna il codice dato da OPA (che solitamente è 200)
    });

}

export default {authorize_operation}