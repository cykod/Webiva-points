class Addpoints < ActiveRecord::Migration
  def self.up
    create_table :points_users, :force => true do |t|
      t.integer :end_user_id
      t.integer :points, :default => 0
      t.timestamps
    end
    
    create_table :points_transactions, :force => true do |t|
      t.integer :points_user_id
      t.integer :end_user_id
      t.integer :amount
      t.boolean :purchased, :default => false
      t.string :note
      t.integer :admin_user_id
      t.string :source
      t.timestamps
    end

    add_index :points_users,:end_user_id, :name => 'user'
    add_index :points_transactions,:points_user_id, :name => 'points_user'
    add_index :points_transactions, :end_user_id, :name => 'user'
  end

  def self.down
    drop_table :points_users
    drop_table :points_transactions
  end
end
