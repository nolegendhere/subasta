class AddDefaultValueToPastAmount < ActiveRecord::Migration
  def up
  change_column :investments, :past_amount, :integer, :default => 0
end

def down
  change_column :investments, :past_amount, :integer, :default => nil
end
end
