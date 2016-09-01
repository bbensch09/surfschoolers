class Lesson < ActiveRecord::Base
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :instructor
  belongs_to :lesson_time
  has_many :students
  accepts_nested_attributes_for :students, reject_if: :all_blank, allow_destroy: true

  validates :activity, :location, :lesson_time, presence: true
  validates :objectives, :duration, :start_time, :ability_level,
            presence: true, on: :update
  # validates :gear, inclusion: { in: [true, false] }, on: :update
  validates :terms_accepted, inclusion: { in: [true], message: 'must accept terms' }, on: :update
  # validates :actual_start_time, :actual_end_time, presence: true, if: :just_finalized?
  validate :instructors_must_be_available, unless: :no_instructors_post_instructor_drop?
  validate :requester_must_not_be_instructor, on: :create
  # validate :lesson_time_must_be_valid
  # validate :student_exists, on: :update

  # after_update :send_lesson_request_to_instructors
  # before_save :calculate_actual_lesson_duration, if: :just_finalized?

  def date
    lesson_time.date
  end

  def slot
    lesson_time.slot
  end

  def resort
    Resort.find(self.location.to_i)
  end

  def active?
    active_states = ['new', 'booked', 'confirmed', 'pending instructor', 'pending requester','']
    active_states.include?(state)
  end

  def new?
    state == 'new'
  end

  def canceled?
    state == 'canceled'
  end

  def pending_instructor?
    state == 'pending instructor'
  end

  def pending_requester?
    state == 'pending requester'
  end

  def finalizing?
    state == 'finalizing'
  end

  def waiting_for_payment?
    state == 'waiting for payment'
  end

  def get_changed_attributes(original_lesson)
    lesson_changes = self.previous_changes
    lesson_time_changes = self.lesson_time.attributes.diff(original_lesson.lesson_time.attributes)
    changed_attributes = lesson_changes.merge(lesson_time_changes)
    changed_attributes.reject { |attribute, change| ['updated_at', 'id', 'state', 'lesson_time_id'].include?(attribute) }
  end

  def available_instructors
    puts "the lesson location is #{self.location}"
    resort = Resort.where("id = ?",self.location).first
    puts "the resort is #{resort.name}"
    resort_instructors = resort.instructors
    puts "there are #{resort_instructors.count} instructors total."
    if self.activity == 'Ski'
        sport = "Ski Instructor"
      else
        sport = "Snowboard Instructor"
    end
    puts "The instructor type sought is: #{sport}"
    eligible_resort_instructors = resort_instructors.where("sport=?",sport)
    puts "Before filtering for booked lessons, there are #{eligible_resort_instructors.count} eligible instructors."
    already_booked_instructors = Lesson.booked_instructors(lesson_time)
    puts "The number of already booked instructors is: #{already_booked_instructors.count}"
    available_instructors = eligible_resort_instructors - already_booked_instructors
    return available_instructors
  end

  def available_instructors?
    available_instructors.any?
  end

  def self.find_lesson_times_by_requester(user)
    self.where('requester_id = ?', user.id).map { |lesson| lesson.lesson_time }
  end

  def self.booked_instructors(lesson_time)
    puts "checking for booked instructors on #{lesson_time.date} during the #{lesson_time.slot} slot"
    if lesson_time.slot == 'Full Day'
      booked_lessons = self.find_all_booked_lessons_in_day(lesson_time)
    else
      booked_lessons = self.find_booked_lessons(lesson_time)
    end
    puts "There is/are #{booked_lessons.count} lesson(s) already booked at this time."
    # booked_lessons.any? ? booked_lessons[0...-1].map { |lesson| Instructor.find(lesson.instructor_id) } : []
    booked_instructors = []
    booked_lessons.each do |lesson|
      booked_instructors << lesson.instructor
    end
    return booked_instructors
  end

  def self.find_booked_lessons(lesson_time)
    self.where('lesson_time_id = ? AND instructor_id is not null', lesson_time.id)
  end

  def self.find_all_booked_lessons_in_day(full_day_lesson_time)
    matching_lesson_times = LessonTime.where("date=?",full_day_lesson_time.date)
    booked_lessons = []
    puts booked_lessons
    puts "The empty array of booked lessons has length: #{booked_lessons.count}"
    puts "--------Collect matching lesson times on this date--------"
    matching_lesson_times.each do |lt|
      lessons_at_lt = Lesson.where("lesson_time_id=? AND instructor_id is not null",lt.id)
      lessons_at_lt.each do |lesson|
        booked_lessons << lesson
        puts "added a booked lesson to the booked_lesson set"
      end
    end
    puts booked_lessons
    puts "After searching through the matching lesson times on this date, the booked lesson count on this day is now: #{booked_lessons.count}"
    return booked_lessons
    # OLD CODE
    # morning_lesson_time = LessonTime.find_morning_slot(full_day_lesson_time.date)
    # afternoon_lesson_time = LessonTime.find_afternoon_slot(full_day_lesson_time.date)
    # full_day_booked_lessons = self.find_booked_lessons(full_day_lesson_time)
    # morning_booked_lessons = self.find_booked_lessons(morning_lesson_time) if morning_lesson_time
    # afternoon_booked_lessons = self.find_booked_lessons(afternoon_lesson_time) if afternoon_lesson_time
    # [full_day_booked_lessons, morning_booked_lessons, afternoon_booked_lessons].flatten
  end

  private

  def instructors_must_be_available
    errors.add(:instructor, " not available at that time. Email info@snowschoolers.com to be notified if there are cancellations.") unless available_instructors.any?
  end

  def requester_must_not_be_instructor
    errors.add(:instructor, "cannot request a lesson") if self.requester.verified_instructor?
  end

  def lesson_time_must_be_valid
    errors.add(:lesson_time, "invalid") unless lesson_time.valid?
  end

  def student_exists
    errors.add(:students, "count must be greater than zero") unless students.any?
  end

  def send_lesson_request_to_instructors
    if 2+2==4 #replace with logic that tests whether lesson is newly complete, vs. already booked, etc.
      LessonMailer.send_lesson_request_to_instructors(self).deliver
    end
  end

  def calculate_actual_lesson_duration
    start_time = Time.parse(actual_start_time)
    end_time = Time.parse(actual_end_time)
    self.actual_duration = (end_time - start_time)/3600
  end

  def just_finalized?
    waiting_for_payment?
  end

  def no_instructors_post_instructor_drop?
    pending_requester?
  end
end
