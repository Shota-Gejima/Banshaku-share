class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.integer :user_id, null: false
      t.integer :alcohol_id, null: false
      t.integer :food_id, null: false
      t.integer :making_time_id, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.text :process, null:false
      t.timestamps
    end
  end
end
