module HashableSetting
  module Core
    module Helpers

      private

      def is_orm?(object)
        %i(id created_at updated_at).each do |sym|
          return if object.try(sym).nil?
        end
        return true
      end

      def is_orm_class?(klass)
        valid_methods = %i(where update create delete)
        return unless methods = find_class(klass)&.methods
        valid_methods.each do |method|
          return if methods.exclude? method
        end
        return true
      end

      def find_class(klass)
        Object.const_get(klass.camelcase)
      rescue
        nil
      end
    end
  end
end