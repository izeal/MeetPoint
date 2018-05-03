class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :all_list, :past_list]
  before_action :set_event, only: [:show]
  before_action :set_current_user_event, only: [:edit, :update, :destroy]

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
    params.require(:event).permit(:title, :datetime, :address, :description)
  end
end
