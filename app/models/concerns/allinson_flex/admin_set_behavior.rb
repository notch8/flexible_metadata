# frozen_string_literal: true

require 'active_support/concern'

module AllinsonFlex
  module AdminSetBehavior
    extend ActiveSupport::Concern

    included do
      before_destroy :remove_from_context
    end

    # override (from Hyrax 2.5.0) - new method (and after_destroy callback)
    #  to remove deleted admin_set from admin_set_ids
    def remove_from_context
      context = metadata_context
      unless context.blank?
        context.admin_set_ids = context.admin_set_ids.reject { |as_id| as_id == id }
        context.save
      end
    end

    # override (from Hyrax 2.5.0) - new method to add metadata_context
    # @api public
    #
    # @return [AllinsonFlex::Context]
    # @raise [ActiveRecord::RecordNotFound]
    def metadata_context
      AllinsonFlex::Context.find_metadata_context_for(
        admin_set_id: id
      )
    end
  end
end
