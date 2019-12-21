class DomainPrice < ApplicationRecord
  #30文字以下
  validates(:domain, presence: true, length: {maximum: 30})
  #Integer型のみ、0より大きい
  validates(:price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0})
  validates(:registrar, presence: true)
end
