#各ユーザー定義タスクで使うデーターベース共通処理
class DataRegister
  def start(hash, registrar, price_type = "update")
    if price_type == "update"
     hash.each do |domain, price|
      begin
          domain_price = DomainPrice.find_or_initialize_by(registrar: registrar, domain: domain)
          domain_price.update_attributes!(update_price: price)
          domain_price.save!
        end
      rescue ActiveRecord::RecordInvalid => e
        pp e.record.errors
        next
      end
    elsif price_type == "register"
      hash.each do |domain, price|
        begin
          domain_price = DomainPrice.find_or_initialize_by(registrar: registrar, domain: domain)
          domain_price.update_attributes!(register_price: price)
          domain_price.save!
        rescue ActiveRecord::RecordInvalid => e
          pp e.record.errors
          next
        end
      end
    end
  end
end
