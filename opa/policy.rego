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
    user_check
}

# operazioni per il controllo dell'utente
user_check {
    role_validation
    check_permission
}

# controlla se il ruolo è coerente.
# questo check è utile solo ai fini della demo. Se avessimo un utente e un id utente, 
# si farebbe il controllo con i dati del db.
role_validation {
    payload["wlcg.groups"][_] == input.role
}

# ""funzione"" per il recupero delle info nel JWT
payload := p {
    [_, p, _] := io.jwt.decode(bearer_token) # decodifica il token
    # decodifica il token e controlla che sia valido, dunque 
    # che exp e nbf siano coerenti
    # [token_is_valid, _, p] := io.jwt.decode_verify(bearer_token, time.now_ns())
}

# Non controlla la validità in tempo del JWT purtroppo, 
# siccome usiamo lo stesso JWT scaduto mille anni fa per testing

# ""funzione"" per la validazione ed estrazione delle informazioni nel Bearer
bearer_token := t {
    v := input.token
	startswith(v, "Bearer ") # controllo che sia effettivamente il bearer_token
	t := substring(v, count("Bearer "), -1) # prendo il token
}