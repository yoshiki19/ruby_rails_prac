class ChangeRoomIdOfEntries < ActiveRecord::Migration[5.2]
  def change
    remove_column :entries, :room_id, :integer
    add_reference :entries, :room, foreign_key: true
  end
end
