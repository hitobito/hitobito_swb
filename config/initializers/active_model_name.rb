# frozen_string_literal: true

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module ActiveModel
  class Name
    module TsManaged
      SUFFIX = "TS"

      attr_reader :ts_role, :ts_membership

      def initialize(*args)
        super
        return unless @klass <= Role

        @ts_role = Ts::ROLE_MAPPINGS.index_by(&:type)[@klass.to_s]
        @ts_membership = Ts::MEMBERSHIP_MAPPINGS.index_by(&:type)[@klass.to_s]
      end

      def human(...)
        ts_role ? "#{super} (#{SUFFIX})" : super
      end
    end
    prepend ActiveModel::Name::TsManaged
  end
end
