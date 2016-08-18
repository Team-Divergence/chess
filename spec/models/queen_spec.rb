require 'rails_helper'

 RSpec.describe Queen, type: :model do
   describe 'valid_move?' do
     it "Should return true when a move is valid" do
       game = FactoryGirl.create(:game, id: 999, white_user_id: 1, black_user_id: 2, winning_user_id: nil)
       queen = FactoryGirl.create(:queen, color: "white", current_position_x: 3, current_position_y: 4, game_id: game.id)
       # Diagonal up left
       expect(queen.valid_move?(2,3)).to eq(true)
       expect(queen.valid_move?(0,1)).to eq(true)
       expect(queen.valid_move?(1,2)).to eq(true)
       expect(queen.valid_move?(2,3)).to eq(true)

       # Diagonal up right
       expect(queen.valid_move?(4,3)).to eq(true)
       expect(queen.valid_move?(5,2)).to eq(true)
       expect(queen.valid_move?(6,1)).to eq(true)

       # Diagonal left down
       expect(queen.valid_move?(2,5)).to eq(true)

       # Diagonal right down
       expect(queen.valid_move?(4,5)).to eq(true)


       # horizontal left
       expect(queen.valid_move?(2,4)).to eq(true)
       expect(queen.valid_move?(1,4)).to eq(true)
       expect(queen.valid_move?(0,4)).to eq(true)


       # horizontal right
       expect(queen.valid_move?(4,4)).to eq(true)
       expect(queen.valid_move?(5,4)).to eq(true)
       expect(queen.valid_move?(6,4)).to eq(true)

       # vertical up
       expect(queen.valid_move?(3,3)).to eq(true)
       expect(queen.valid_move?(3,2)).to eq(true)
       expect(queen.valid_move?(3,1)).to eq(true)

       # vertical down
       expect(queen.valid_move?(3,5)).to eq(true)

      end

      it "Should return false when a move is invalid" do
        game = FactoryGirl.create(:game, id: 999, white_user_id: 1, black_user_id: 2, winning_user_id: nil)
        queen = FactoryGirl.create(:queen, color: "white", current_position_x: 3, current_position_y: 4, game_id: game.id)
         expect(queen.valid_move?(1,3)).to eq(false)
         expect(queen.valid_move?(6,5)).to eq(false)
         expect(queen.valid_move?(7,5)).to eq(false)


      end
     end
  end
