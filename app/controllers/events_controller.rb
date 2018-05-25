class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :all_list, :past_list]
  before_action :set_event, only: [:show]
  before_action :set_current_user_event, only: [:edit, :update, :destroy]
  before_action :pincode_guard!, only: [:show]
  def index
    @events = Event.paginate(:page => params[:page], :per_page => 12).future
  end

  def show
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])
    @subscription = current_user.subscriptions.find_by(event_id: @event.id) if current_user
    @new_photo = @event.photos.build(params[:photo])
  end

  def new
    @event = current_user.events.build
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: I18n.t('controllers.events.created')
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      render :edit
    end
  end

  def destroy
    user = @event.user
    @event.destroy
    redirect_to user_path(user), notice: I18n.t('controllers.events.destroyed')
  end

  def past_list
    @events = Event.paginate(:page => params[:page], :per_page => 12).past
    render :index
  end

  def all_list
    @events = Event.paginate(:page => params[:page], :per_page => 12).asc
    render :index
  end

  private

  def set_current_user_event
    @event = current_user.events.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :datetime, :address, :description, :pincode)
  end

  def pincode_guard!
    return true if @event.pincode.blank?
    return true if @event.user == current_user

    if current_user
      if params[:pincode] && @event.pincode_valid?(params[:pincode])
        cookies.permanent["events_#{@event.id}_pincode"] = params[:pincode]
      end

      unless @event.pincode_valid?(cookies.permanent["events_#{@event.id}_pincode"])
        flash.now[:alert] = t('controllers.events.pin_alert') if params[:pincode]
        render 'pincode_form'
      end
    else
      redirect_to new_user_session_path, notice: t('controllers.events.redirect')
    end
  end
end
