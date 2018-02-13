class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :eventname
      t.string :location
      t.datetime :start_at
      t.datetime :end_at
      t.integer :createdby
      t.boolean :is_public

      t.timestamps
    end
  end
end
