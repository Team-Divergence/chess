require 'rails_helper'

RSpec.describe King, type: :model do
  game = FactoryGirl.create(:game)
  king = FactoryGirl.create(:king, current_position_x: 0, current_position_y: 3, color: 'black')
  describe 'is_valid_move?' do
    it 'should return false if move_to square is off board' do
      expect(king.is_valid_move?(9, 9)).to eq(false)
    end

    it 'should return false if move_to square is same square' do
      expect(king.is_valid_move?(0, 3)).to eq(false)
    end

    it 'should return false if move_to square contains piece with same color' do
      expect(king.is_valid_move?(0,0)).to eq(false) 
    end
    
    it 'should return false when a move is out of range for King' do
      expect(king.is_valid_move?(0, 5)).to be(false)
    end

    it 'should return true when a move is in range for King' do
      expect(king.is_valid_move?(0, 4)).to be(true)
    end
  end
end