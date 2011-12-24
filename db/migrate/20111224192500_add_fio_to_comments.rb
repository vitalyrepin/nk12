class AddFioToComments < ActiveRecord::Migration
  def change
    add_column :comments, :fio, :string
  end
end
