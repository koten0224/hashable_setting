class Setting < ApplicationRecord
  include HashableSetting
  belongs_to :owner, polymorphic: true
  VALID_KLASS = %w(string integer boolean hash array).freeze

  validates :klass, inclusion: VALID_KLASS, if: -> {klass.present?}
  before_save :default_klass

  def default_klass
    unless klass
      self.klass = 'string'
    end
  end

  def display_value
    eval_list = {
      string: -> {value},
      integer: -> {value.to_i},
      boolean: -> {value == 'true'}
    }
    eval_list[klass.to_sym].call
  end

end
