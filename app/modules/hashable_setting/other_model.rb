module HashableSetting
  module OtherModel
    include Core::Base
    def self.included(base)
      base.extend Core::ClassMethods
      base.class_eval do
        before_save :save_body
      end
    end

    def save_body
      @body&.save
    end
  end
end