class SubscriptionsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]
  before_action :check_email_duplication, only: [:create]

  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if current_user == @event.user
      redirect_to @event, alert: I18n.t('controllers.subscription.alert_for_owner')
    elsif @new_subscription.save
      redirect_to @event, notice: I18n.t('controllers.subscription.created')
      EventNotifier.execute(@new_subscription)
    else
      render 'events/show', alert: I18n.t('controllers.subscription.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.subscription.destroyed') }

    if current_user_can_edit?(@subscription)
      @subscription.destroy!
      EventNotifier.execute(@subscription)
    else
      message = { alert: I18n.t('controllers.subscription.error') }
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_name, :user_email)
  end

  def check_email_duplication
    return if current_user
    if User.find_by(email: subscription_params[:user_email])
      redirect_to @event, alert: I18n.t('controllers.subscription.email_duplication')
    end
  end
end
