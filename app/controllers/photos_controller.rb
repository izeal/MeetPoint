class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      redirect_to @event, notice: I18n.t('controller.photos.created')
    else
      render 'events/show', alert: I18n.t('controller.photos.error')
    end
  end

  def destroy
    message = I18n.t('controller.photos.destroyed')
    if current_user_can_edit?
      @photo.destroy
    else
      message = I18n.t('controller.photos.error')
    end
    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_photo
    @photo = Event.photos.find(params[:id])
  end

  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end
