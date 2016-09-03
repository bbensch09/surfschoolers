class AddMoreFieldsToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :activity, :string
    add_column :lessons, :requested_location, :string
    add_column :lessons, :phone_number, :string
    add_column :lessons, :gear, :boolean
    add_column :lessons, :student_count, :integer
    add_column :lessons, :objectives, :text
  end
end
