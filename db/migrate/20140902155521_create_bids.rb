class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|

      t.string 	:name
      t.string 	:category
      t.string 	:subcategory
      t.integer :price
      t.integer :user_id
      t.integer :auction_id

      t.timestamps
    end
    add_index :bids, [:user_id, :created_at]
    add_index :bids, :auction_id
  end
end
