module HashableSetting
  module Core
    module Definers

      private

      def define_setting_by_key(key, value)
        sub_set = find_or_new_setting(key)
        sub_set.value = value
        to_h if @body.nil?
        @body[key] = sub_set.value
        define_as_single_value(@body, sub_set)
      end

      def define_as_single_value(body, sub_setting)
        key = sub_setting.name
        read_method = key
        write_method = "#{key}="
        body.define_singleton_method(read_method) do
          # puts sub_setting.object_id
          sub_setting.value
        end
        body.define_singleton_method(write_method) do |value|
          # puts sub_setting.object_id
          sub_setting.value = body[key] = value
        end
        define_singleton_method(read_method) do
          # puts sub_setting.object_id
          sub_setting.value
        end
        define_singleton_method(write_method) do |value|
          # puts sub_setting.object_id
          sub_setting.value = body[key] = value
        end
      end
    end
  end
end