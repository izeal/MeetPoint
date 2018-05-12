module EventNotifier
  def self.execute(model)
    case model.class
    when Comment
      if model.destroyed?
        EventMailer.model_destroyed(model, model.user.email).deliver_now
      else
        emails = participants_emails(model)
        emails.each { |mail| EventMailer.comment(model, mail).deliver_now }
      end

    when Photo
      if model.destroyed?
        EventMailer.model_destroyed(model, model.user.email).deliver_now
      else
        emails = participants_emails(model)
        emails.each { |mail| EventMailer.photo(model, mail).deliver_now }
      end

    when Subscription
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
