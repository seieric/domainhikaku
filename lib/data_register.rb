class DataRegister #各ユーザー定義タスクで使うデーターベース共通処理
  def self.start(hash, rgstr_no) #hashの構造=>{".com"=>[1200,1300]},rgstr=>Int
    registrar = config(rgstr_no)
    hash.each do |domain, price|
      next unless price.is_a?(Array)  #配列じゃなければスキップ
      begin
          domain_price = DomainPrice.find_or_initialize_by(registrar: registrar, domain: domain)
          domain_price.update_attributes!(update_price: price[-1], register_price: price[0])
      rescue ActiveRecord::RecordInvalid => e
        logger.error(e.record.errors)
        p e.record.errors
        next
      end
    end
  end

  def self.add(domain, language = "en", )

  def self.config(int)
    registrars = [
      "x_domain",
      "value_domain",
      "muumuu_domain",
      "onamae_com",
      "star_domain"
    ]
    registrars[int]
  end
  private_class_method :config
end
