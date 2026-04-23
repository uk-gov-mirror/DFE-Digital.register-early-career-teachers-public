module Metadata::Handlers
  class Teacher < Base
    attr_reader :teacher

    def initialize(teacher)
      @teacher = teacher
    end

    def refresh_metadata!
      upsert_lead_provider_metadata!
    end

    class << self
      def destroy_all_metadata!
        truncate_models!(Metadata::TeacherLeadProvider)
      end
    end

  private

    def upsert_lead_provider_metadata!
      lead_provider_ids.each do |lead_provider_id|
        metadata = existing_lead_provider_metadata[lead_provider_id] ||
          Metadata::TeacherLeadProvider.new(teacher:, lead_provider_id:)

        latest_ect_training_period = latest_ect_training_period_by_lead_provider(teacher:)[lead_provider_id]
        latest_mentor_training_period = latest_mentor_training_period_by_lead_provider(teacher:)[lead_provider_id]
        latest_ect_contract_period = latest_ect_training_period&.contract_period || latest_ect_training_period&.expression_of_interest_contract_period
        latest_mentor_contract_period = latest_mentor_training_period&.contract_period || latest_mentor_training_period&.expression_of_interest_contract_period
        api_mentor_id = latest_ect_training_period&.at_school_period&.latest_mentorship_period&.mentor&.teacher&.api_id
        involved_in_school_transfer = school_transfers_exist_for(teacher.ect_at_school_periods, lead_provider_id) ||
          school_transfers_exist_for(teacher.mentor_at_school_periods, lead_provider_id)

        changes = {
          teacher_id: teacher.id,
          lead_provider_id:,
          latest_ect_training_period_id: latest_ect_training_period&.id,
          latest_mentor_training_period_id: latest_mentor_training_period&.id,
          latest_ect_contract_period_year: latest_ect_contract_period&.year,
          latest_mentor_contract_period_year: latest_mentor_contract_period&.year,
          api_mentor_id:,
          involved_in_school_transfer:
        }

        commit_changes!(metadata, changes)
      end
    end

    def existing_lead_provider_metadata
      @existing_lead_provider_metadata ||= Metadata::TeacherLeadProvider
        .where(teacher:, lead_provider_id: lead_provider_ids)
        .index_by(&:lead_provider_id)
    end

    def latest_ect_training_period_by_lead_provider(teacher:)
      @latest_ect_training_period_by_lead_provider ||= TrainingPeriod
        .joins(Arel.sql(training_period_resolved_lead_provider_joins_sql))
        .includes(
          :ect_at_school_period,
          :expression_of_interest_lead_provider,
          lead_provider_delivery_partnership: { active_lead_provider: :lead_provider }
        )
        .where(ect_at_school_period: { teacher: })
        .select(Arel.sql("DISTINCT ON (#{resolved_lead_provider_id_sql}) training_periods.*, #{resolved_lead_provider_id_sql} AS resolved_lead_provider_id"))
        .order(Arel.sql("#{resolved_lead_provider_id_sql}, training_periods.started_on DESC"))
        .index_by(&:resolved_lead_provider_id)
    end

    def latest_mentor_training_period_by_lead_provider(teacher:)
      @latest_mentor_training_period_by_lead_provider ||= TrainingPeriod
        .joins(Arel.sql(training_period_resolved_lead_provider_joins_sql))
        .includes(
          :mentor_at_school_period,
          :expression_of_interest_lead_provider,
          lead_provider_delivery_partnership: { active_lead_provider: :lead_provider }
        )
        .where(mentor_at_school_period: { teacher: })
        .select(Arel.sql("DISTINCT ON (#{resolved_lead_provider_id_sql}) training_periods.*, #{resolved_lead_provider_id_sql} AS resolved_lead_provider_id"))
        .order(Arel.sql("#{resolved_lead_provider_id_sql}, training_periods.started_on DESC"))
        .index_by(&:resolved_lead_provider_id)
    end

    def resolved_lead_provider_id_sql
      <<~SQL.squish
        COALESCE(
          school_active_lead_providers.lead_provider_id,
          expression_of_interest_active_lead_providers.lead_provider_id
        )
      SQL
    end

    def training_period_resolved_lead_provider_joins_sql
      <<~SQL.squish
        LEFT JOIN school_partnerships
          ON school_partnerships.id = training_periods.school_partnership_id
        LEFT JOIN lead_provider_delivery_partnerships
          ON lead_provider_delivery_partnerships.id = school_partnerships.lead_provider_delivery_partnership_id
        LEFT JOIN active_lead_providers school_active_lead_providers
          ON school_active_lead_providers.id = lead_provider_delivery_partnerships.active_lead_provider_id
        LEFT JOIN active_lead_providers expression_of_interest_active_lead_providers
          ON expression_of_interest_active_lead_providers.id = training_periods.expression_of_interest_id
      SQL
    end

    def school_transfers_exist_for(school_periods, lead_provider_id)
      ::API::Teachers::SchoolTransfers::History.exists_for?(school_periods:, lead_provider_id:)
    end
  end
end
