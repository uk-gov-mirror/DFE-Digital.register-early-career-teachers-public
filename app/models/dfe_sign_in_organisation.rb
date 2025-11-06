class DfESignInOrganisation < ApplicationRecord
  # Associations
  has_one :appropriate_body, foreign_key: :dfe_sign_in_organisation_id, primary_key: :uuid
  has_one :school, foreign_key: :urn, primary_key: :urn

  # Validations
  validates :name,
            presence: true,
            uniqueness: true

  validates :uuid,
            presence: true,
            uniqueness: true

  # If a DSI org is added by hand, stamp the time of its first use when used
  def last_authenticated_at=(datetime)
    self.first_authenticated_at ||= datetime
    super
  end
end
