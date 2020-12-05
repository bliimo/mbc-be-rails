class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find_by_id(params[:conversation_id])
    user = User.find_by_id(params[:user_id])

    if conversation.present?
      stream_for conversation
      return
    end

    if user.present?
      stream_for user
      return
    end

    streaming_room = StreamingRoom.find(params[:room])
    stream_for streaming_room
  end

  def receive(data); end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
