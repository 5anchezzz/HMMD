class RenameStatusFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :status
    add_column :users, :state, :string
  end
end
