module HashableSetting
  module Core
    module ValueTransformers

      private

      def to_h
        return if try(:klass) && klass != 'hash'
        return @body if @body
        find_all_settings
        @body = Dict.define_by_children(self)
        @body.keys.each do |key|
          define_as_single_value(key)
        end
        @body
      end

      def to_a
        return if try(:klass) && klass != 'array'
        return @body if @body
        find_all_settings
        @body = List.define_by_children(self)
      end
    end
  end
end