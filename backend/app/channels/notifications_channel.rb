class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    #token = params['authorization_token']
    user = params["user"].to_s
    
    # Open stream for a parameterized channel
    
    stream_from "notification_user_#{user}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
