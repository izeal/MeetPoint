class AddDeviseToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :users do |t|
      t.change :email, :string, null: false, default: "", unique: true
      t.string :encrypted_password, null: false, default: ""

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
