module HashableSetting
  module Core
    module Base
      include Helpers
      include Finders
      include Definers
      include ValueTransformers

      VALID_CONTAINERS = %w(hash array).freeze

      def setting(key=nil, value: nil)
        # in this documentaion:
        #   define the key means symbol
        #   define the value means string, integer, boolean, or symbol

        #   expect the following are legal:
        #   setting => return a hash
        #   setting(value: hash)
        #   setting(key, value: hash)
        #   setting(key, value: array)
        #   setting(key, value: value)

        #   expect the following are inlegal:
        #   setting(hash)
        #   setting(array)
        #   setting(value: array)
        #   setting(value)
        #   setting(value: value)
        return to_h if key.nil? && value.nil?
        key, value = nil, key if value.nil?
        if key.is_a? Symbol
          define_setting_by_key(key, value)
        elsif value.is_a? Hash
          value.each do |key, val|
            define_setting_by_key(key, val)
          end
        end
      end

      # def all_children_save
      #   if all_children.present?
      #     all_children.each do |sub_set|
      #       sub_set.save if sub_set.changed?
      #     end
      #   end
      #   @body = nil
      # end
      def all_children
        find_all_settings
        children + children.map(&:all_children).flatten
      end
      
      def all_children_save
        save_settings_by_array(all_children)
        @body = nil
      end

      def save_settings_by_array(array)
        if array.present?
          array.each do |sub_set|
            sub_set.save if sub_set.changed?
          end
        end
      end

      def delete_settings_by_array(array)
        if array.present?
          array.each do |sub_set|
            sub_set.delete
          end
        end
      end
    end
  end
end