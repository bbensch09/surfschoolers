class LessonMailer < ActionMailer::Base
  default from: 'brian@snowschoolers.com'

  def new_user_signed_up(user)
    @user = user
    mail(to: 'brian@snowschoolers.com', subject: "A new user has registered for Snow Schoolers")
  end

  def subscriber_sign_up(beta_user)
    @beta_user = beta_user
    mail(to: 'brian@snowschoolers.com', subject: "Someone has subscribed to the Snow Schoolers mailing list")
  end

  def send_lesson_request_to_instructors(lesson, excluded_instructor=nil)
    @lesson = lesson
    available_instructors = (lesson.available_instructors - [excluded_instructor])
    @available_instructors = []
    available_instructors.each do |instructor|
      @available_instructors << instructor.user.email
    end
    mail(to: 'notify@snowschoolers.com', bcc: @available_instructors, subject: 'New Snow Schoolers lesson request')
  end

  def send_lesson_request_to_new_instructors(lesson, excluded_instructor=nil)
    @lesson = lesson
    available_instructors = (lesson.available_instructors - [excluded_instructor])
    @available_instructors = []
    available_instructors.each do |instructor|
      @available_instructors << instructor.user.email
    end
    mail(to: 'notify@snowschoolers.com', bcc: @available_instructors, subject: 'A previous instructor canceled - can you help with this lesson request?')
  end

  # notification when instructor cancels
  def send_cancellation_confirmation(lesson)
    @lesson = lesson
    mail(to: @lesson.instructor.user.email, cc:'notify@snowschoolers.com', subject: 'You have canceled your Snow Schoolers lesson')
  end

  def send_lesson_confirmation(lesson)
    @lesson = lesson
    mail(to: @lesson.requester.email, cc:'notify@snowschoolers.com', bcc:@lesson.instructor.user.email, subject: 'Your Snow Schoolers lesson has been confirmed')
  end

  def send_lesson_update_notice_to_instructor(original_lesson, updated_lesson, changed_attributes)
    @original_lesson = original_lesson
    @updated_lesson = updated_lesson
    @changed_attributes = changed_attributes
    mail(to: @updated_lesson.instructor.user.email, cc:'notify@snowschoolers.com', subject: 'One of your Snow Schoolers lesson has been updated')
  end

  # notification when client cancels
  def send_cancellation_email_to_instructor(lesson)
    @lesson = lesson
    mail(to: @lesson.instructor.user.email, cc:'notify@snowschoolers.com', bcc: @lesson.requester.email, subject: 'One of your Snow Schoolers lessons has been canceled')
  end

  def inform_requester_of_instructor_cancellation(lesson, available_instructors)
    @lesson = lesson
    @available_instructors = available_instructors
    mail(to: @lesson.requester.email, cc:'notify@snowschoolers.com', subject: 'Your Snow Schoolers lesson has been canceled')
  end

  def send_payment_email_to_requester(lesson)
    @lesson = lesson
    mail(to: @lesson.requester.email, cc:'notify@snowschoolers.com', subject: 'Please complete your Snow Schoolers lesson payment')
  end
end
