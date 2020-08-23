module HashableSetting
  module Core
    module ClassMethods
      def self.extended(base)
        base.class_eval do
          attr_accessor :children
          attr_reader :body
          has_many :settings, as: :owner, dependent: :destroy, autosave: true
          before_save :all_children_save
        end
      end
    end
  end
end