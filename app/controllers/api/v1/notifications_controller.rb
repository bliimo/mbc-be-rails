class Api::V1::NotificationsController < Api::V1::ApiController
  before_action :set_notification, only: %i[ show edit update destroy read ]
  before_action :require_user_login

  def index
    @page = params[:page] || 1
    @per = params[:per] || 2

    @notifications = Notification.all
    @count = @notifications.count
    @notifications = @notifications.page(@page).per(@per)
    @notifications = assign_user(@notifications, @user)

    render json: {
      notifications: @notifications.as_json(methods: [:game, :is_read], include: [:user]), 
      count: @count, 
      limit_value: @notifications.limit_value,
      total_pages: @notifications.total_pages,
      current_page: @notifications.current_page,
      next_page: @notifications.next_page,
      prev_page: @notifications.prev_page,
    }
  end

  def in_app_notifications
    @notifications = Notification.all.to_be_notified
    @notifications = assign_user(@notifications, @user)
    @notifications = filter_unread_notifications(@notifications)
    
    render json: @notifications, methods: [:game, :is_read]
  end

  def show
    @notification.current_user_id = @user.id
    render json: @notification, methods: [:game, :is_read]
  end
     
  def read
    @user_notification = UserNotification.where(
      user_id: @user.id,
      notification_id: @notification.id
    )
    if @user_notification.count > 0
      @user_notification = @user_notification.first
    else
      @user_notification = UserNotification.create(
        user_id: @user.id,
        notification_id: @notification.id
      )
    end
    render json: @user_notification
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.user = @user
    if @notification.save
      if @notification.schedule > DateTime.now
        GameSchedulerJob.set(
          wait_until: @notification.schedule
        ).perform_later(@notification)
      else
        GameSchedulerJob.perform_later(@notification)
      end

      render json: @notification, methods: [:game]
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      render json: @notification, methods: [:game]
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy
    render json: {message: "Notification successfully deleted", notification: @notification}
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:title, :description, :game_id, :schedule)
    end

    def assign_user(notifications, user)
      notifications.each{|notification| notification.assign_attributes(current_user_id: user.id)}
      notifications
    end

    def filter_unread_notifications(notifications)
      notifications.select { |notification| !notification.is_read }
    end
end
