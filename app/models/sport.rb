class Sport < ApplicationRecord
  has_many :user_sports, dependent: :destroy
  has_many :users, through: :user_sports

  enum sport_name: { surf: 0, kitesurf: 1, pesca: 2 }
end

# == Schema Information
#
# Table name: sports
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sport_name :integer
#
