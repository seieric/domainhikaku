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
end
