class CreateTugs < ActiveRecord::Migration[6.1]
  def change
    create_table :tugs do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
