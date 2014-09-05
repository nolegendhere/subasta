class AddInitialActualCashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :initial_cash, :integer, default: 0
    add_column :users, :actual_cash, :integer, default: 0
  end
end
