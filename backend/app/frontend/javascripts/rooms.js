
function newRoomButton(event) {
    console.log("clicked!");
    // fetch("/chatrooms/get_id", {
    //     credentials: 'same-origin'  
    // }).then(res => res.json())
    // .then(response => {
    //     $("#chatroom_room_code").attr("value", response["roomCode"]);
    //     console.log(response["roomCode"])
    // });
    $('#new-room-modal').modal("show");
};

function sendMessage(event) {
    event.preventDefault()
    let formData = new FormData(document.getElementById("new-msg-form"));
    fetch('/messages/new', {
    method: 'POST',
    body: formData
    })
    .then(response => response.json())
    .catch(error => console.error('Error:', error))
    .then(response => {
        console.log(response)
        if (response["status"] === 400) {
            let msg = response["msg"]
            $("#chatbox").append(
                `<div class="my-msg bg-danger my-1 px-3 py-1 ml-auto">
                <div clas="msg-container">
                    <div class="msg-body text-white text-wrap">
                        ${msg.body}
                    </div>
                    <div class="msg-foot text-right text-white-50 text-small">
                        (No enviado)
                    </div>
                </div>
            </div>`
            )
            var objDiv = document.getElementById("chatbox");
            objDiv.scrollTop = objDiv.scrollHeight;
        } else {
            $("#message_body").val("");
        }
    });

    return false
}

$(document).ready(()=>{
    console.log("page loaded :ok_hand:");
    document.getElementById("new-msg-form").addEventListener("submit", sendMessage)
    $("#new-msg-form").keypress(function(e){
        if(e.keyCode == 13) {
            sendMessage(e)
        }
    })
});


console.log("ready :+1:");