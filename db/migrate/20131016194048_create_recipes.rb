class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :components
      t.integer :servings

      t.timestamps
    end
  end
end
