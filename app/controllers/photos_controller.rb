class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      redirect_to @event, notice: I18n.t('controllers.photos.created')

      participants_emails(@new_photo).each do |email|
        EventMailer.photo_created(@new_photo, email).deliver_now
      end
    else
      render 'events/show', alert: I18n.t('controllers.photos.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.photos.destroyed') }
    if current_user_can_edit?(@photo)
      @photo.destroy!
      EventMailer.photo_destroyed(@photo).deliver_now
    else
      message = { alert: I18n.t('controllers.photos.error') }
    end
    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_photo
    @photo = @event.photos.find(params[:id])
  end

  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end
