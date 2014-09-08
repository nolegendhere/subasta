class AddDefaultValueToActualInitialCash < ActiveRecord::Migration
  	def up
	  change_column :wallets, :initial_cash, :integer, :default => 0
	  change_column :wallets, :actual_cash, :integer, :default => 0
	end

	def down
	  change_column :wallets, :initial_cash, :integer, :default => nil
	  change_column :wallets, :actual_cash, :integer, :default => nil
	end
end
