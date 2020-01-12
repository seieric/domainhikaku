class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception #Ajaxセキュリテートークンの生成

  before_filter :ensure_domain
  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host
    redirect_to "https://saiyasu.me#{request.path}", status: :moved_permanently
  end
end
