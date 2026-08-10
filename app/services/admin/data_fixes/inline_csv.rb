module Admin::DataFixes
  class InlineCSV
    class InvalidHeaderError < ArgumentError; end

    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    EXPECTED_HEADERS = %w[object_type object_id action attributes].freeze
    Row = Data.define(*EXPECTED_HEADERS)

    attribute :csv_string, :string

    validates :csv_string, presence: true

    def parse
      return false unless valid?

      CSV.parse(csv_string, headers: true, header_converters: header_converter).map do |row|
        Row.new(**row)
      end
    rescue CSV::MalformedCSVError => _e
      errors.add(:csv_string, "is malformed")
      false
    rescue InvalidHeaderError => _e
      errors.add(:csv_string, "has invalid headers")
      false
    end

  private

    def header_converter
      proc { it.in?(EXPECTED_HEADERS) ? it : raise(InvalidHeaderError) }
    end
  end
end
