module HashableSetting
  module Core
    module ValueTransformers

      private

      def to_h
        return if try(:klass) && klass != 'hash'
        return @body if @body
        @body = Dict.new(self)
        find_all_settings
        children.reduce(@body) do |hash, sub_set|
          hash[sub_set.name] = sub_set.value
          hash
        end
      end

      def to_a
        return if try(:klass) && klass != 'array'
        return @body if @body
        @body = []
        children.reduce(@body) do |array, sub_set|
          array.push(sub_set.value)
          array
        end
      end
    end
  end
end