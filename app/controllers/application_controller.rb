class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception #Ajaxセキュリテートークンの生成
end
