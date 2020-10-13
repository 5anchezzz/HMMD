class AddDoneParamsToVisit < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :late, :boolean
    add_column :visits, :negative, :boolean
    add_column :visits, :interval, :boolean
  end
end
