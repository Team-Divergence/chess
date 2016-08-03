FactoryGirl.define do
  factory :game do
    name "Hello"
  end

  factory :piece do
    current_position_x 4
    current_position_y 4
    association :game
  end
end
