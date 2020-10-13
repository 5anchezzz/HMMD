class AddInfoToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :birthday, :date
    add_column :users, :sex, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :phone, :string
    add_column :users, :organization_name, :string
    add_column :users, :organization_address, :string
    add_column :users, :field_of_activity, :string
    add_column :users, :start_hour, :integer
    add_column :users, :end_hour, :integer
    add_column :users, :holiday, :boolean
    add_column :users, :slot_size, :integer
    add_column :users, :status, :string
  end
end
