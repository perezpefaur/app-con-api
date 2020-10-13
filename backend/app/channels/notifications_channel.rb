class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    token = params['authorization_token']
    user = User.find_by({authentication_token: token})
    if user && user.id.to_s == params["user"].to_s
      # Open stream for a parameterized channel
    
      stream_from "notification_user_#{user.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
