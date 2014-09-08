class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.integer :actual_cash
      t.integer :initial_cash
      t.integer :user_id

      t.timestamps
    end
    add_index :wallets, :user_id
  end
end
