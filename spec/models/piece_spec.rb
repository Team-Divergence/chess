require 'rails_helper'

RSpec.describe Piece, type: :model do
  game = FactoryGirl.create(:game)
  piece_1 = FactoryGirl.create(:piece)
  piece_2 = FactoryGirl.create(:piece, current_position_x: 6, current_position_y: 6)
  describe '.is_obstructed?' do
    it 'should return nil on invalid input' do
      expect(piece_1.is_obstructed?(5, 7)).to eq(nil)
    end

    it 'should return true on obstruction' do
      expect(piece_1.is_obstructed?(8, 8)).to eq(true)
    end

    it 'should return false on no obstruction' do
      expect(piece_1.is_obstructed?(4, 6)).to eq(false)
    end
  end
end
