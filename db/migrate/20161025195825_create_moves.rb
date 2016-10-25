class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer  "game_id"
      t.integer  "piece_id"
      t.integer  "start_position_x"
      t.integer  "start_position_y"
      t.integer  "end_position_x"
      t.integer  "end_position_y"

      t.timestamps
    end
  end
end
