# Questa versione del server supporta solo delle POST ad esso praticamente. 
# Il nostro web server farebbe esattamente questo, ovvero invia a OPA i dati della 
# richiesta, per controllora se passa oppure no.

package server_rules

import input.http_method as http_method    # il metodo HTTP che la nostra regola deve analizzare.
                        # Rego non ha delle funzioni builtin per fare l'handling del HTTP requests (giustamente)
                        # siccome questi in teoria li deve ricevere da un server esterno

default allow = false # impedisce, se non trova la regola, di dare accesso


# questo è il caso base
allow {
    input.uses_jwt == "false"
    # print 
    # input.uses_jwt == false
    check_permission
}

check_permission {
    all := data.roles[input.role][_]
    all == input.operation
}

# ----------------------------------------------

# questo è il caso in cui abbiamo un jwt
allow {
    input.uses_jwt == "true"
    allow_jwt
}

# allow è la regola base del nostra regola
allow_jwt {
    # input.uses_jwt == "true"
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
    [_, p,_] := io.jwt.decode(bearer_token) # decodifica il token
}

# ""funzione"" per la validazione ed estrazione delle informazioni nel Bearer
bearer_token := t {
    v := input.token
	startswith(v, "Bearer ") # controllo che sia effettivamente il bearer_token
	t := substring(v, count("Bearer "), -1) # prendo il token
}