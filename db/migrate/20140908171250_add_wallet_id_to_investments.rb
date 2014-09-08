class AddWalletIdToInvestments < ActiveRecord::Migration
  def change
  	add_column 	:investments, :wallet_id, :integer
  	add_index 	:investments, :wallet_id
  end
end
