class AddPastAmountToInvestments < ActiveRecord::Migration
  def change
    add_column :investments, :past_amount, :integer
  end
end
