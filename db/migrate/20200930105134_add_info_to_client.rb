class AddInfoToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :description, :text
    add_column :clients, :blocked, :boolean
  end
end
