class UserSport < ApplicationRecord
  belongs_to :user
  belongs_to :sport
end

# == Schema Information
#
# Table name: user_sports
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  sport_id   :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_sports_on_sport_id  (sport_id)
#  index_user_sports_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (sport_id => sports.id)
#  fk_rails_...  (user_id => users.id)
#
