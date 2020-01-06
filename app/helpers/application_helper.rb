module ApplicationHelper
  #<title>タグ内に入れるタイトルを生成
  def full_title(page_title = "")
    base_title = "最安ドメイン検索"

    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

#bootstrapで現在のページを濃く表示
  def class_active?(path)
    "active" if current_page?(path)
  end

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
      "onamae_com"    => "https://www.onamae.com/",
      "x_domain"      => "https://www.xdomain.ne.jp/",
      "value_domain"  => "https://www.value-domain.com/",
      "muumuu_domain" => "https://muumuu-domain.com/"
    }
    list[registrar]
  end
  def show_domain(domain)
    domain.gsub("/prefectures/ja-jp/","(都道府県名日本語)").gsub("/prefectures/","(都道府県名)").gsub("/ja-jp/","(日本語)")
  end
end
