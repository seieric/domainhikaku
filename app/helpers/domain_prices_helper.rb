module DomainPricesHelper
  #データベースの値から正式名称を出力
  def show_registrar(registrar)
    list = {
      "onamae_com"    => "お名前.com",
      "x_domain"      => "エックスドメイン",
      "value_domain"  => "バリュードメイン",
      "muumuu_domain" => "ムームードメイン"
    }
    list[registrar]
  end
  def show_link(registrar)
    list = {
      "onamae_com"    => "https://af.moshimo.com/af/c/click?a_id=1522047&p_id=109&pc_id=109&pl_id=2745&guid=ON",
      "x_domain"      => "https://www.xdomain.ne.jp/",
      "value_domain"  => "https://www.value-domain.com/",
      "muumuu_domain" => "https://muumuu-domain.com/"
    }
    list[registrar]
  end
  def show_domain(domain)
    domain.gsub("/ja-jp/","（日本語）").gsub("/prefectures/ja-jp/","（都道府県名日本語）").gsub("/prefectures/","（都道府県名）")
  end
end
