class EventMailer < ApplicationMailer
  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email, subject: "Новая подписка на #{event.title}"
  end

  def subscription_destroyed(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email, subject: "От #{event.title} отписались"
  end

  def comment(event, comment, email)
    @comment = comment
    @event = event

    mail to: email, subject: "Новый комментарий на #{event.title}"
  end

  def comment_destroyed(event, comment, email)
    @comment = comment
    @event = event

    mail to: email, subject: "Комментарий для #{event.title} удален"
  end

  def photo(event, photo, email)
    @photo = photo
    @event = event

    mail to: email, subject: "В #{event.title} добавили фотографию!"
  end

  def photo_destroyed(event, photo, email)
    @photo = photo
    @event = event

    mail to: email, subject: "Из #{event.title} удалили фотографию!"
  end
end
