class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :bid_id
      t.integer :user_id
      t.integer :amount

      t.timestamps
    end
    add_index :investments, [:user_id, :created_at]
    add_index :investments, :bid_id
  end
end
