class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.boolean :violation
      t.integer :commission_id
      t.timestamps
    end
  end
end
