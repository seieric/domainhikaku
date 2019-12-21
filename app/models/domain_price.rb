#カラムpriceが負になってはいけない
class CannotBeNegativeValidator < ActiveModel::Validator
  def validate(record)
    if record.price.present? && record.price < 0
      record.errors[:price] << ":price cannot be negative"
    end
  end
end

class DomainPrice < ApplicationRecord
  validates(:domain, presence: true, length: {maximum: 30})
  validates(:price, presence: true, cannot_be_negative: true) #負の値は禁止
  validates(:registrar, presence: true)

  def cannot_be_negative
    if price.present? && price < 0
      errors.add(:price, ":price cannot be negative")
    end
  end
end
