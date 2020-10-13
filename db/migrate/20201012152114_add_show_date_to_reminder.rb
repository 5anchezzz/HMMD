class AddShowDateToReminder < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :show_date, :date
  end
end
