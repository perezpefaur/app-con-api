class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    room = params['room']
    
    # Open stream for a parameterized channel
    stream_from "messages_#{room}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
