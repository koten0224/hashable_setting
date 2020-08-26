module HashableSetting
  module Core
    module Definers

      private
      def define_new_key(key)
        read_method = key
        write_method = "#{key}="
        define_singleton_method(read_method) do
          @body[key]
        end
        define_singleton_method(write_method) do |value|
          @body[key]=value
        end
      end
    end
  end
end