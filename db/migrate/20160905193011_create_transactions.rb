class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :lesson_id
      t.integer :requester_id
      t.float :base_amount
      t.float :tip_amount
      t.float :final_amount

      t.timestamps
    end
  end
end
