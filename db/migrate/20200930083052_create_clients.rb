class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :surname
      t.string :email
      t.string :phone
      t.date :birthday
      t.string :sex

      t.timestamps
    end
  end
end
