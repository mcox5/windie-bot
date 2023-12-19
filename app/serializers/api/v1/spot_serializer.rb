class Api::V1::SpotSerializer < ActiveModel::Serializer
  attributes :name,
             :windguru_code,
             :report,
             :report_last_update
end
