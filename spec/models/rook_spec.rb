require 'rails_helper'

RSpec.describe Rook, type: :model do
  game = FactoryGirl.create(:game)
  rook = FactoryGirl.create(:rook)

  describe 'valid_move?' do
    it 'should return true when a move is valid' do
      expect(rook.valid_move?(4, 3)).to be(true)
      expect(rook.valid_move?(4, 6)).to be(true)
      expect(rook.valid_move?(1, 4)).to be(true)
      expect(rook.valid_move?(7, 4)).to be(true)
    end

    it 'should return false when a move is not valid' do
      expect(rook.valid_move?(5, 5)).to be(false)
      expect(rook.valid_move?(3, 6)).to be(false)
      expect(rook.valid_move?(1, 8)).to be(false)
      expect(rook.valid_move?(2, 7)).to be(false) 
    end
  end
end
