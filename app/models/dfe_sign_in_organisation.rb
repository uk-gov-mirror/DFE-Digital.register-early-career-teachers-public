class DfESignInOrganisation < ApplicationRecord
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
