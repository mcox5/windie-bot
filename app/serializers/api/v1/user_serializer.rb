class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :alias,
             :phone
end
