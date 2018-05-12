class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      redirect_to @event, notice: I18n.t('controllers.photos.created')
      notify_participants(@new_photo)
    else
      render 'events/show', alert: I18n.t('controllers.photos.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.photos.destroyed') }
    if current_user_can_edit?(@photo)
      @photo.destroy!
      notify_participants(@photo)
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

  def notify_participants(photo)
    emails = participants_emails(photo.event)
    if photo.destroyed?
      emails.each {
        |mail| EventMailer.photo_destroyed(photo, mail).deliver_now
      }
    else
      emails.each {
        |mail| EventMailer.photo(photo, mail).deliver_now
      }
    end
  end
end
