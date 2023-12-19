class Api::V1::Webhook::BaseController < Api::BaseController
  before_action do
    self.namespace_for_serializer = ::Api::V1::Webhook
  end
end
