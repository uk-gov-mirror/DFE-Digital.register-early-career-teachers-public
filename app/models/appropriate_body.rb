class AppropriateBody < ApplicationRecord
  # Enums
  enum :body_type,
       { local_authority: 'local_authority',
         national: 'national',
         teaching_school_hub: 'teaching_school_hub' },
       validate: { message: "Must be local authority, national or teaching school hub" }

  # Associations
  has_many :pending_induction_submissions
  has_many :induction_periods, inverse_of: :appropriate_body
  has_many :events
  belongs_to :dfe_sign_in_organisation, foreign_key: :uuid, primary_key: :dfe_sign_in_organisation_id, inverse_of: :appropriate_body

  # Validations
  validates :name,
            presence: true,
            uniqueness: true

  normalizes :name, with: -> { it.squish }
end
