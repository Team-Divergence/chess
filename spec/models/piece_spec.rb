require 'rails_helper'

RSpec.describe Piece, type: :model do
  game = FactoryGirl.create(:game)
  piece_1 = FactoryGirl.create(:piece, current_position_x: 0, current_position_y: 0)
  piece_2 = FactoryGirl.create(:piece, current_position_x: 0, current_position_y: 1)
  piece_3 = FactoryGirl.create(:piece, current_position_x: 3, current_position_y: 3, color: 'black')
  piece_4 = FactoryGirl.create(:piece, current_position_x: 0, current_position_y: 7)
  piece_5 = FactoryGirl.create(:piece, current_position_x: 0, current_position_y: 6)
  piece_6 = FactoryGirl.create(:piece, current_position_x: 7, current_position_y: 5)
  piece_7 = FactoryGirl.create(:piece, current_position_x: 7, current_position_y: 0)
  piece_8 = FactoryGirl.create(:piece, current_position_x: 7, current_position_y: 1)
  piece_9 = FactoryGirl.create(:piece, current_position_x: 3, current_position_y: 4)
  piece_10 = FactoryGirl.create(:piece, current_position_x: 7, current_position_y: 7)
  piece_11 = FactoryGirl.create(:piece, current_position_x: 7, current_position_y: 1)
  describe 'obstructed?' do
    context 'when there is an obstruction' do
      it 'should return true' do
        # black pieces
        # expect(piece_1.obstructed?(0, 2)).to eq(true) # downward vertical blocked
        expect(piece_1.obstructed?(0, 3)).to eq(true) # downward vertical blocked
        expect(piece_1.obstructed?(2, 0)).to eq(true) # right horizontal blocked
        # expect(piece_2.obstructed?(2, 1)).to eq(true) # right horizontal blocked
        expect(piece_1.obstructed?(3, 3)).to eq(true) # downright diagonal blocked
        expect(piece_7.obstructed?(5, 2)).to eq(true) # downleft diagonal blocked
        expect(piece_11.obstructed?(5, 1)).to eq(true) # left horizontal blocked

        # white pieces
        expect(piece_4.obstructed?(0, 5)).to eq(true) # upward vertical blocked
        expect(piece_4.obstructed?(2, 5)).to eq(true) # up-right diagonal blocked
        expect(piece_10.obstructed?(5, 5)).to eq(true) # upleft diagonal blocked
      end
    end

    context 'when there is not an obstruction' do
      it 'should return false' do
        # black pieces
        expect(piece_2.obstructed?(0, 3)).to eq(false) # downward vertical not blocked
        expect(piece_2.obstructed?(2, 3)).to eq(false) # downright diagonal not blocked
        # expect(piece_2.obstructed?(4, 5)).to eq(false) # downright diagonal not blocked -> long move
        expect(piece_8.obstructed?(5, 3)).to eq(false) # downleft diagonal not blocked
        # white pieces
        expect(piece_5.obstructed?(0, 4)).to eq(false) # upward vertical not blocked
        expect(piece_5.obstructed?(2, 4)).to eq(false) # upright diagonal not blocked
        expect(piece_6.obstructed?(5, 5)).to eq(false) # left horizontal not blocked
        expect(piece_6.obstructed?(5, 3)).to eq(false) # upleft diagonal not blocked
        expect(piece_9.obstructed?(5, 4)).to eq(false) # right horizontal  not blocked

      end
    end
  end

  describe 'valid_move?' do
    it 'should return false if move_to square is off board' do
      expect(piece_1.valid_move?(9, 9)).to eq(false)
    end

    it 'should return false if move_to square is same square' do
      expect(piece_2.valid_move?(0, 1)).to eq(false)
    end

    it 'should return false if move_to square contains piece with same color' do
      expect(piece_3.valid_move?(0, 0)).to eq(false)
    end

    it 'should return true if move_to square is on board, is a different square and does not contain piece with same color' do
      expect(piece_3.valid_move?(3, 4)).to eq(true)
    end
  end

  describe 'move_to!' do
    it 'should update has_moved attribute to true' do
      piece_3.move_to!(0, 4)
      expect(piece_3.has_moved).to eq(true)
    end
  end

end
