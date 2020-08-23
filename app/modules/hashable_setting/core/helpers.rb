module HashableSetting
  module Core
    module Helpers

      private

      def iter_function_for(klass)
        case klass
        when 'hash' then :each # .... do |key, value|
        when 'array' then :each_with_index # .... do |value, index|
        end
      end

      def key_and_value_switcher(klass, value_a, value_b)
        case klass
        when 'hash' then [value_a, value_b]
        when 'array' then [value_b, value_a]
        else nil
        end
      end

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