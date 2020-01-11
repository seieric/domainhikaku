module ApplicationHelper
  #<title>タグ内に入れるタイトルを生成
  def full_title(page_title = "")
    base_title = "最安ドメイン比較"

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
      "muumuu_domain" => "ムームードメイン",
      "star_domain"   => "スタードメイン"
    }
    list[registrar]
  end
  def show_link(registrar)
    list = {
      "onamae_com"    => "https://www.onamae.com/",
      "x_domain"      => "https://www.xdomain.ne.jp/",
      "value_domain"  => "https://www.value-domain.com/",
      "muumuu_domain" => "https://muumuu-domain.com/",
      "star_domain"   => "https://www.star-domain.jp/"
    }
    list[registrar]
  end
  def show_domain(domain)
    domain.gsub("/prefectures/ja-jp/","(都道府県名日本語)").gsub("/prefectures/","(都道府県名)").gsub("/ja-jp/","(日本語)")
  end

  def default_meta_tags(description = "", keywords = "")
    {
      charset: 'utf-8',
      description: description,
      keywords: keywords,
      canonical: request.original_url,
      og: {
        site_name: '最安ドメイン比較',
        title: full_title,
        description: description,
        type: 'website',
        url: request.original_url,
        image: image_url('card1.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@saiyasu_domain',
      }
    }
  end
end
