class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :label
      t.string :description
      t.date :date
      t.time :start
      t.integer :duration
      t.integer :value
      t.string :state

      t.timestamps
    end
  end
end
