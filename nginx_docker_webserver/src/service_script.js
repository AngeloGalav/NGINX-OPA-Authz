import BEARER_TOKEN from './env.js'

$(document).ready(function() {
    $('.btn').on("click", (elem) => {

        let role_ = $('#user_role').val();
        let operation_;
        let http_method = 'POST';

        // registro l'operazione
        if ($(elem.target).hasClass("read")) {
            operation_ = "retrieve";
        }
        else if ($(elem.target).hasClass("write")) operation_ = "submit";
        else if ($(elem.target).hasClass("report")) operation_ = "report";
        else if ($(elem.target).hasClass("getres")) {
            operation_ = "getres";
            http_method = 'GET'
        }
        else operation_ = null;

        // infine invia la richiesta   
        $.ajax({
            url: 'https://pippocnaf.test.example:8081/operation/' + operation_,
            type: http_method,
            contentType: 'application/json',
            dataType : "json",
            headers: { // tocca mettere le informazioni necessarie nell'header
               'Authorization':  $('#jwt_enabled').is(":checked") ? `Bearer ${BEARER_TOKEN}` : "",
               'X-Role' : role_,
               'X-EnableJWT' : $('#jwt_enabled').is(":checked"),
               "X-Operation" : operation_
            },
            data : JSON.stringify({
                operation : operation_,
                role : role_ // questo poi lo mettiamo nell'access token
            }),
            success: function (result) {
                $("#command_output").val(result.status + " - " + result.statusText);
            },
            error: function (result) {
                $("#command_output").val(result.status + " - " + result.statusText); 
            }
        });
    });

    // abilita il JWT. In questo modo, posso usare il JWT ufficale dell'INFN per poter
    // loggarmi facilmente al nostro server. Unica cosa, ho solo un JWT, che ha ruolo /dev...
    // Dunque, nel codice, se l'utente usa l'opzione JWT avrà solo permessi da dev
    $('#jwt_enabled').on('change', () => {
        if ($('#jwt_enabled').is(":checked")) {
            $('#user_role').attr('disabled', true);
            $('#user_role').val('dev');
        }
        else $('#user_role').attr('disabled', false);
    });

});



