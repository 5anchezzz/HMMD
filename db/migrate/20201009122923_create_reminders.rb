class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :visit, null: false, foreign_key: true
      t.string :label
      t.text :description
      t.string :state
      t.integer :days_to_show

      t.timestamps
    end
  end
end
