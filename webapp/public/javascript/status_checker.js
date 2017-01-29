/**
 * Created by andre on 1/28/17.
 *
 * Manages updating the status on a regular basis
 */
function is_server_on(){
    $.ajax({
        url: '/status',
        success: function(resp){
            resp = JSON.parse(resp);
            return resp.status;
        },
        failure: function(){
            console.log('An error occurred when attempting to get the server\'s status');
        }
    });
}

var status_element = $('#server-status');
var interval = 5000;
setInterval(function(){
    if(is_server_on()){
        console.log('Server is on');
        status_element.attr('class', 'server-status-on');
    } else {
        console.log('Server is off');
        status_element.attr('class', 'server-status-off');
    }

    interval += 5000;
}, interval);