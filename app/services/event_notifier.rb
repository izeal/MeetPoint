###
#
# этот файл оставлю просто на память - мой первый модуль)
#

module EventNotifier
  extend self

  def execute(model)
    case
    when model.class == Comment then comment_sender(model)
    when model.class == Photo then photo_sender(model)
    when model.class == Subscription then subscription_sender(model)
    end
  end

  private

  def participants_emails(model)
    (model.event.subscriptions.preload(:user).map(&:user_email) + [model.event.user.email] - [model.user.try(:email)]).uniq
  end

  def comment_sender(model)
    if model.destroyed?
      EventMailer.comment_destroyed(model, model.user.email).deliver_now
    else
      emails = participants_emails(model)
      emails.each { |mail| EventMailer.comment(model, mail).deliver_now }
    end
  end

  def photo_sender(model)
    if model.destroyed?
      EventMailer.photo_destroyed(model, model.user.email).deliver_now
    else
      emails = participants_emails(model)
      emails.each { |mail| EventMailer.photo(model, mail).deliver_now }
    end
  end

  def subscription_sender(model)
    if model.destroyed?
      EventMailer.subscription_destroyed(model).deliver_now
    else
      EventMailer.subscription(model).deliver_now
    end
  end
end
