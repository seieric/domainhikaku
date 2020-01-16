class DomainPrice < ApplicationRecord
  #30文字以下
  validates(:domain, presence: true, length: {maximum: 30})
  validates(:language, length: {maximum: 10})
  #Integer型のみ、0以上
  validates(:register_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0})
  validates(:update_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0})
  validates(:registrar, presence: true)

  def domain_price_params
    params.require(:domain).permit(:register_price, :update_price, :registrar)
  end

  def self.search(query)
    return self.all unless query
    query = "/prefectures/" if query.include?("都道府県")
    self.where(['domain LIKE ?', "%#{query}%"])
  end
end
