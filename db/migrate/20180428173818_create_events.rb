class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :datetime, null: false
      t.text :description

      t.timestamps
    end
  end
end
