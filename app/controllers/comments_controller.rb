class CommentsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      redirect_to @event, notice: I18n.t('controllers.comments.created')
      # notify_participants(@new_comment)
      EventNotifier.execute(@new_comment)
    else
      render 'events/show', alert: I18n.t('controllers.comments.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.comments.destroyed')}
    if current_user_can_edit?(@comment)
      @comment.destroy!
      # notify_participants(@comment)
      EventNotifier.execute(@comment)
    else
      message = { alert: I18n.t('controllers.comments.error')}
    end
    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end

  # def notify_participants(comment)
  #   if comment.destroyed?
  #     comment.user.email.each {
  #       |mail| EventMailer.comment_destroyed(comment, mail).deliver_now
  #     }
  #   else
  #     emails = participants_emails(comment.event)
  #     emails.each {
  #       |mail| EventMailer.comment(comment, mail).deliver_now
  #     }
  #   end
  # end
end
