class WelcomeController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @lesson = Lesson.new
    @lesson_time = @lesson.lesson_time
  end
end
