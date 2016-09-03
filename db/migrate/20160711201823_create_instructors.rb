class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :certification
      t.string :phone_number
      t.string :preferred_locations
      t.string :sport
      t.string :bio
      t.string :intro
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
