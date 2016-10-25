FactoryGirl.define do
  factory :move do
    
  end
  factory :user do
    sequence :email do |n|
      'dummyEmail#{n}@gmail.com'
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :game do
    name 'Divergence'
  end

  factory :piece do
    current_position_x 4
    current_position_y 4
    association :game

    factory :pawn, class: Pawn do
      type "Pawn"
    end

    factory :rook, class: Rook do
      type "Rook"
    end

    factory :knight, class: Knight do
      type "Knight"
    end

    factory :bishop, class: Bishop do
      type "Bishop"
    end

    factory :queen, class: Queen do
      type "Queen"
    end

    factory :king, class: King do
      type "King"
    end
  end

end
