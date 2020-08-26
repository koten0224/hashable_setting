module HashableSetting
  module Core
    module Base
      include Helpers
      include Finders
      include Definers
      include ValueTransformers

      VALID_CONTAINERS = %w(hash array).freeze
      VALID_KEYS = [Symbol, String].freeze

      def setting(key=nil, value=nil)
        p [key, value]
        # in this documentaion:
        #   define the key means symbol
        #   define the value means string, integer, boolean, or symbol

        #   expect the following are legal:
        #   setting => return a hash
        #   setting(hash)
        #   setting(key, hash)
        #   setting(key, array)
        #   setting(key, value)

        #   expect the following are inlegal:
        #   setting(array)
        #   setting(array)
        #   setting(value)
        #   setting(value)
        return to_h if key.nil? && value.nil?
        key, value = nil, key if value.nil?
        if VALID_KEYS.include? value.class
          define_setting_by_key(key, value)
        elsif value.is_a? Hash
          value.each do |key, val|
            define_setting_by_key(key, val)
          end
        end
      end
    end
  end
end