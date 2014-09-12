class AddAllObjectsToChoices < ActiveRecord::Migration
  def change
  	add_column :choices, :all_objects, :boolean
  end
end
