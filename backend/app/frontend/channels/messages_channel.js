import consumer from "./consumer"

$(function() {
    $('[data-channel-subscribe="room"]').each(function(index, element) {
      var $element = $(element),
          room_id = $element.data('room-id'),
          current_user = $element.data('current-user');
          $element.removeAttr("data-current-user");
  
      $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)        
  
      consumer.subscriptions.create(
        {
          channel: "MessagesChannel",
          room: room_id
        },
        {
            connected() {
              // Called when the subscription is ready for use on the server
              $("#no-conneted").fadeOut("slow")
            },
          
            disconnected() {
              // Called when the subscription has been terminated by the server
              document.getElementsByClassName("alerts-container")[0].innerHTML += `<div class="alert alert-danger alert-dismissible fade show" role="alert" id="no-conneted">
              Se ha perdido la conexión al servidor
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
              </button>
          </div>`
            },
          
            received(response) {
              // Called when there's incoming data on the websocket for this channel
              // console.log(response)
              if (response["server"]) {
                $("#chatbox").append(
                    `
                    <div class="server-msg rounded-pill bg-secondary text-center w-25 mx-auto my-1 text-wrap">${response.data.body}</div>`
                )
          
              } else {
                  let msg = response["data"];
                  let msg_date = msg.created_at;
                  let username = msg.username;
                  let date_str = `${msg_date[0]}-${msg_date[1]}-${msg_date[2]}`
                  let dates = $('[data-date="' + date_str + '"]');
                  if (dates.length === 0) {
                    $("#chatbox").append(`
                    <div class="server-msg rounded-pill bg-info text-center w-25 mx-auto text-white my-1" data-date="${date_str}" >
                    ${date_str}
                    </div>`)
                  }

                  if (username == current_user) {
                    $("#chatbox").append(
                        `
                        <div class="my-msg bg-success ml-auto my-1 px-3 py-1">
                            <div clas="msg-container">
                                <div class="msg-body text-white text-wrap">
                                ${msg.body}
                                </div>
                                <div class="msg-foot text-right text-white-50 text-small">
                                ${msg_date[3]}:${msg_date[4]}
                                </div>
                            </div>
                        </div>`
                    ) 
                  } else {
                    $("#chatbox").append(
                        `
                        <div class="other-msg bg-primary my-1 px-3 py-1">
                            <div clas="msg-container">
                                <div class="msg-head text-left">
                                ${msg.username}
                                </div>
                                <div class="msg-body text-white text-wrap">
                                ${msg.body}
                                </div>
                                <div class="msg-foot text-right text-white-50 text-small">
                                ${msg_date[3]}:${msg_date[4]}
                                </div>
                            </div>
                        </div>`
                    ) 
                  };
                  var objDiv = document.getElementById("chatbox");
                  objDiv.scrollTop = objDiv.scrollHeight;
              }
            }
        });
    });
  });
