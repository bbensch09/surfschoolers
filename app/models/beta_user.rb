class BetaUser < ActiveRecord::Base
    after_create :send_admin_notification

  def send_admin_notification
      @beta_user = BetaUser.last
      LessonMailer.subscriber_sign_up(@beta_user).deliver
      puts "an admin notification has been sent."
  end

end
