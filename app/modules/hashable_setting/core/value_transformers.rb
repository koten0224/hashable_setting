module HashableSetting
  module Core
    module ValueTransformers

      private

      def to_h
        return if try(:klass) && klass != 'hash'
        return @body if @body
        find_all_settings
        @body = Dict.define_by_children(self)
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