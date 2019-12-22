#各ユーザー定義タスクで使うデーターベース共通処理
class DataRegister
  def start(hash, rgstr_no) #hashの構造=>{".com"=>[1200,1300]},rgstr=>Int
    registrar = self.config(rgstr_no)
    hash.each do |domain, price|
      begin
          domain_price = DomainPrice.find_or_initialize_by(registrar: registrar, domain: domain)
          domain_price.update_attributes!(update_price: price[-1], register_price: price[0])
          domain_price.save!
      rescue ActiveRecord::RecordInvalid => e
        pp e.record.errors
        next
      end
    end
  end

  def config(int)
    registrars = [
      "x_domain",
      "value_domain",
      "x_domain"
    ]
    registrars[int]
  end
end
