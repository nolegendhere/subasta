class AddMaxActualAmountToBids < ActiveRecord::Migration
  def change
    add_column :bids, :max_amount, :integer, default: 0
    add_column :bids, :actual_amount, :integer, default: 0
    add_column :bids, :actual_amount_id, :integer
  end
end
