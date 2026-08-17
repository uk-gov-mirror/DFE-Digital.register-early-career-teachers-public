module Admin::DataFixes
  class Changes
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :parsed_rows

    validate :successful_results

    def process
      return false unless valid?

      results
    end

  private

    def results = @results ||= parsed_rows.map { process_row(it) }

    def process_row(row)
      Processor.new.process!(data_change: row.with_indifferent_access)
    end

    def successful_results
      results.each { errors.add(:parsed_rows, it.error) unless it.success? }
    end
  end
end
