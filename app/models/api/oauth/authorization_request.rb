module API
  module OAuth
    class AuthorizationRequest
      include ActiveModel::Model
      include ActiveModel::Attributes

      RESPONSE_TYPE = "code"

      attribute :response_type, :string
      attribute :client_id, :string
      attribute :appropriate_body_period_id, :integer
      attribute :redirect_uri, :string
      attribute :code_challenge, :string
      attribute :code_challenge_method, :string
      attribute :state, :string
      attribute :logged_in_appropriate_body_period_id, :integer

      validates :response_type, inclusion: { in: [RESPONSE_TYPE] }
      validates :code_challenge, presence: true
      validates :code_challenge_method, inclusion: { in: Authorization.code_challenge_methods.values }
      validates :appropriate_body_period_id, comparison: { equal_to: :logged_in_appropriate_body_period_id }
      validates :client, presence: true
      validates :redirect_uri, inclusion: { in: ->(request) { request.client.redirect_uris } }, if: :client

      def client = @client ||= Client.find_by(client_id:)

      def redirectable? = redirect_uri.present? && client&.redirect_uris&.include?(redirect_uri)

      def redirect_uri_with(error:)
        uri = URI.parse(redirect_uri)
        existing = URI.decode_www_form(uri.query.to_s)
        uri.query = URI.encode_www_form(existing + { error:, state: state.presence }.compact.to_a)
        uri.to_s
      end
    end
  end
end
