class ChangeDurationTypeForVisit < ActiveRecord::Migration[6.0]

  def self.up
    change_table :visits do |t|
      t.change :duration, :float
    end
  end
  def self.down
    change_table :visits do |t|
      t.change :duration, :integer
    end
  end

end
