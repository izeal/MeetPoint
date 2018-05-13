module EventNotifier
  def self.execute(model)
    case
    when model.class == Comment
      if model.destroyed?
        EventMailer.comment_destroyed(model, model.user.email).deliver_now
      else
        emails = participants_emails(model)
        emails.each { |mail| EventMailer.comment(model, mail).deliver_now }
      end

    when model.class == Photo
      if model.destroyed?
        EventMailer.photo_destroyed(model, model.user.email).deliver_now
      else
        emails = participants_emails(model)
        emails.each { |mail| EventMailer.photo(model, mail).deliver_now }
      end

    when model.class == Subscription
      if model.destroyed?
        EventMailer.subscription_destroyed(model).deliver_now
      else
        EventMailer.subscription(model).deliver_now
      end
    end
  end

  def self.participants_emails(model)
    (model.event.subscriptions.preload(:user).map(&:user_email) + [model.event.user.email] - [model.user.try(:email)]).uniq
  end
end
