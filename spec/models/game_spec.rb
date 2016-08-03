require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'populate_board!' do
    it 'it should populate board with 32 pieces' do
      g = Game.create
      expect(g.pieces.count).to eq(32)
    end

    it 'should check that there are 16 Black pieces and they are in the correct position' do
      g = Game.create
      # check black
      y1_pieces = g.pieces.where(current_position_y: 1)
      expect(y1_pieces.count).to eq(8)

      y1_pieces.each_with_index do |piece, index|
        expect(piece.current_position_x).to eq index
        expect(piece.type).to eq 'Pawn'
        expect(piece.color).to eq 'black'
      end

      y0_pieces = g.pieces.where(current_position_y: 0).order(:current_position_x)
      expect(y0_pieces.map { |piece| piece.type }).to eq(['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook'])
      expect(y0_pieces.map { |piece| piece.color }).to eq(['black'] * 8)
    end

    it 'should check that there are 16 White pieces and they are in the correct position' do
      g = Game.create
      # check white
      y6_pieces = g.pieces.where(current_position_y: 6)
      expect(y6_pieces.count).to eq(8)
      y6_pieces.each_with_index do |piece, index|
        expect(piece.current_position_x).to eq index
        expect(piece.type).to eq 'Pawn'
        expect(piece.color).to eq 'white'
      end

      y7_pieces = g.pieces.where(current_position_y: 7).order(:current_position_x)
      expect(y7_pieces.map { |piece| piece.type }).to eq(['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook'])
      expect(y7_pieces.map { |piece| piece.color }).to eq(['white'] * 8)
    end
  end
end
