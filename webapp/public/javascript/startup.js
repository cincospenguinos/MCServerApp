/**
 * Created by andre on 1/27/17.
 *
 * Manages starting up the server.
 */

/**
 * Shows a message
 */
function showStartupRequestMessage(successful, message){
    var alertSpace = $('#startup-request-alert-space');
    var alert;
    if (successful) {
        alert = $('<div/>', {
            'class': 'alert alert-success'
        });

        alert.append('<strong>Success! </strong>');
    } else {
        alert = $('<div/>', {
            id: '',
            'class': 'alert alert-danger'
        });

        alert.append('<strong>Error: </strong>');
    }

    alert.append('<a href="#" class="close" data-dismiss="alert">&times;</a>');
    alert.append(message);
    alertSpace.append(alert);
}

/**
 * Returns true if the startup request is valid.
 *
 * @returns {boolean}
 */
function validateStartupRequest(){
    var username = $.trim($('#send-startup-username').val());
    var password = $.trim($('#send-startup-password').val());

    return !(username.length === 0 || password.length === 0);
}

function sendStartupRequest(){
    var username = $.trim($('#send-startup-username').val());
    var password = $.trim($('#send-startup-password').val());

    $.post({
        url: '/startup',
        data: { username: username, password: password },
        success: function(resp){
            resp = JSON.parse(resp);

            if(resp.successful){
                showStartupRequestMessage(true, 'The server will startup shortly');
                $('#send-startup-username').val('');
                $('#send-startup-password').val('');
            } else {
                showStartupRequestMessage(false, resp.message);
            }
        },
        error: function(){
            showStartupRequestMessage(false, 'There was a server side error. Please let Andre know.');
        }
    });
}

$('#send-startup-button').click(function(){
    console.log('Request button pressed');
    if(validateStartupRequest())
        sendStartupRequest();
    else
        showStartupRequestMessage(false, 'Username and password are required');
});