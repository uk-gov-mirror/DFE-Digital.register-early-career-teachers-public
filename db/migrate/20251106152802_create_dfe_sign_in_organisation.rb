class CreateDfESignInOrganisation < ActiveRecord::Migration[8.0]
  def change
    create_table :dfe_sign_in_organisations do |t|
      t.string :name
      t.uuid :uuid
      t.string :urn
      t.string :address
      t.string :company_registration_number
      t.string :category
      t.string :organisation_type
      t.string :status
      t.datetime :first_authenticated_at
      t.datetime :last_authenticated_at

      t.timestamps
    end
  end
end
