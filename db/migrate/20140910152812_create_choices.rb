class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|

      t.boolean :pg, default: false
      t.boolean :sg, default: false
      t.boolean :sf, default: false
      t.boolean :pf, default: false
      t.boolean :ce, default: false
      t.boolean :player, default: false
      t.boolean :team, default: false
      t.boolean :max_amount, default: false
      t.boolean :min_amount, default: false
      t.boolean :max_time, default: false
      t.boolean :min_time, default: false
      t.integer :user_id

      t.timestamps
    end
    add_index :choices, :user_id
  end
end
