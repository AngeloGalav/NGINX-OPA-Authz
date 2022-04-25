function authorize_operation(r) {

    // dati da inviare a OPA
    let opa_data = {
        "operation" : r.headersIn["X-Operation"],
        "role" : "/" + r.headersIn["X-Role"],
        "uses_jwt" : r.headersIn["X-EnableJWT"],
        "token" : r.headersIn["Authorization"]
    }

    // pacchetto HTTP da inviare ad
    var opts = {
        method: "POST",
        body: JSON.stringify(opa_data)
    };
    
    // gestisce la risposta di OPA
    r.subrequest("/_opa", opts, function(opa_res) {
        r.log("OPA Responded with status " + opa_res.status);
        r.log(JSON.stringify(opa_res));

        var body = JSON.parse(opa_res.responseText);
        
        if (!body) {
            r.return(403);
            return;
        }

        if (!body.allow) {
            r.return(403);
            return;
        }

        r.return(opa_res.status);
    });

}

export default {authorize_operation}