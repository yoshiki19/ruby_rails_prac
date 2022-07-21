class AddTermsOfUseToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :terms_of_use, :text
  end
end
