class Issue < ActiveRecord::Base
  belongs_to :project
  # validate :handle_conflict

  # def handle_conflict
  #   logger.debug "validate #{updated_at}"
  # end
end
