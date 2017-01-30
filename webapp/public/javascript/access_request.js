/**
 * Created by andre on 1/30/17.
 *
 * Manages access requests.
 */
function showAccessRequestMessage(successful, message){
    var alertSpace = $('#access-request-alert-space');
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

function submitAccessRequest(){
    var username = $.trim($('#access-request-username').val());
    var password = $.trim($('#access-request-password').val());
    var emailAddress = $.trim($('#access-request-email').val());

    $.post({
        url: '/access',
        data: { username: username, password: password, email_address: emailAddress },
        success: function(resp){
            resp = JSON.parse(resp);
            if(resp.successful){
                showAccessRequestMessage(resp.successful, 'Andre has been notified of your request.');

                $('#access-request-username').val('');
                $('#access-request-password').val('');
                $('#access-request-email').val('');
            } else
                showAccessRequestMessage(resp.successful, resp.message);
        },
        error: function(){
            showAccessRequestMessage(false, 'A server side error occurred. Please contact Andre to let him know');
        }
    });
}

function verifyAccessRequest(username, password, emailAddress){
    var testEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    testEmail = testEmail.test(emailAddress);
    
    return testEmail && username.length > 0 && password.length > 0;
}


$('#submit-access-request').click(function(){
    var username = $.trim($('#access-request-username').val());
    var password = $.trim($('#access-request-password').val());
    var emailAddress = $.trim($('#access-request-email').val());

    if(verifyAccessRequest(username, password, emailAddress)){
        submitAccessRequest();
    } else {
        showAccessRequestMessage(false, 'Username, password or email address not provided or not valid')
    }
});