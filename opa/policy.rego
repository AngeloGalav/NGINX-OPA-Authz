# Questa versione del server supporta solo delle POST ad esso praticamente. 
# E il nostro web server adempisce esattamente a questo, ovvero invia a OPA i dati della 
# richiesta, per controllare se passa oppure no, attraverso una POST. 

package server_rules

import input.http_method as http_method    # il metodo HTTP che la nostra regola deve analizzare.
                        # Rego non ha delle funzioni builtin per fare l'handling del HTTP requests (giustamente)
                        # siccome questi in teoria li deve ricevere da un server esterno

default allow = false # Impedisce, se non trova la regola, di dare accesso (default deny)


# questo è il caso base
allow {
    input.uses_jwt == "false"
    check_permission
}

check_permission {
    all := data.roles[input.role][_]
    all == input.operation
}

# -------------------JWT Rules------------------------

# questo è il caso in cui abbiamo un jwt
allow {
    input.uses_jwt == "true"
    allow_jwt
    # token_is_valid
}

# allow è la regola base del nostra regola
allow_jwt {
    check_permission_jwt
    check_time_valid
}

# controlla se i ruoli dell'utente sono coerenti con l'operazione che vuole svolgere
check_permission_jwt {
    data.roles[payload["wlcg.groups"][_]][_]
            == input.operation
}

check_time_valid {
    payload.exp >= time.now_ns()
} else { # caso in cui il token non scade mai 
    payload.iat == payload.exp
    payload.exp == payload.nbf
}

# ""funzione"" per la validazione ed estrazione delle informazioni nel Bearer
payload := p {
    v := input.token
	startswith(v, "Bearer ") # controllo che sia effettivamente il bearer_token
	t := substring(v, count("Bearer "), -1) # prendo il token
    [_, p, _] := io.jwt.decode(t)
}