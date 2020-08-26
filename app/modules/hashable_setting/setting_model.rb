module HashableSetting
  module SettingModel
    include Core::Base
    def self.included(base)
      base.extend Core::ClassMethods
      base.class_eval do
        belongs_to :owner, polymorphic: true
        validates :name, uniqueness: {scope: :owner}
        scope :valid, -> { where.not(name: [nil, '']) }
        before_save :default_klass
      end
    end
    VALID_CLASSES = %w(
          string
          integer
          true_class
          false_class
          hash
          array
          symbol
          ).freeze
    
    VALID_CONTAINERS = %w(
      hash
      array
    ).freeze

    def transform_klass
      if klass == 'dict'
        self.klass = 'hash'
      elsif klass == 'list'
        self.klass = 'array'
      end
    end

    def default_klass
      transform_klass
      unless is_orm_class?(klass) || VALID_CLASSES.include?(klass)
        self.klass = 'string'
      end
    end

    def value
      return find_class(klass).find(self['value']) if is_orm_class?(klass)
      eval_list = {
        'string' => -> {self['value']},
        'symbol'=> -> {self['value'].to_sym},
        'integer' =>  -> {self['value'].to_i},
        'true_class' =>  -> {true},
        'false_class' => -> {false},
        'hash' => -> {to_h},
        'array' => -> {to_a}
      }
      eval_list[klass]&.call
    end

    def value=(value)
      value_class = value.class.name.underscore
      self.klass ||= value_class
      return if klass && klass != value_class
      if is_orm?(value)
        self['value'] = value.id
      elsif VALID_CONTAINERS.include? value_class
        self['value'] = nil
      else
        self['value'] = value
      end
    end
  end
end