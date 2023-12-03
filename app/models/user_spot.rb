class UserSpot < ApplicationRecord
  belongs_to :user
  belongs_to :spot
end

# == Schema Information
#
# Table name: user_spots
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  spot_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_spots_on_spot_id  (spot_id)
#  index_user_spots_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (spot_id => spots.id)
#  fk_rails_...  (user_id => users.id)
#
