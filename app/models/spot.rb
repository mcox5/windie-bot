class Spot < ApplicationRecord
  has_many :user_spots, dependent: :destroy
  has_many :users, through: :user_spots
end

# == Schema Information
#
# Table name: spots
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  windguru_code      :integer
#  report             :json
#  report_last_update :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
