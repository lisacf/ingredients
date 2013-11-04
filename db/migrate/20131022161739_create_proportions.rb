class CreateProportions < ActiveRecord::Migration
  def change
    create_table :proportions do |t|
      t.integer :ingredient_id
      t.integer :recipe_id
      t.float :amount
      t.string :measure
      t.string :comment

      t.timestamps
    end
  end
end
