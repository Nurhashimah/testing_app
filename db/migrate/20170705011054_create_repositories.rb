class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :title
      t.integer :staff_id
      t.text :data

      t.timestamps
    end
  end
end
