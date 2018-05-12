class EventMailer < ApplicationMailer
  def subscription(subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = subscription.event

    mail to: event.user.email, subject: "Новая подписка на #{@event.title}"
  end

  def subscription_destroyed(subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = subscription.event

    mail to: event.user.email, subject: "От #{@event.title} отписались"
  end

  def comment(comment, email)
    @comment = comment
    @event = @comment.event

    mail to: email, subject: "Новый комментарий на #{@event.title}"
  end

  def comment_destroyed(comment, email)
    @comment = comment
    @event = @comment.event

    mail to: email, subject: "Комментарий для #{@event.title} удален"
  end

  def photo(photo, email)
    @photo = photo
    @event = @photo.event

    mail to: email, subject: "В #{@event.title} добавили фотографию!"
  end

  def photo_destroyed(photo, email)
    @photo = photo
    @event = @photo.event

    mail to: email, subject: "Из #{@event.title} удалили фотографию!"
  end
end
