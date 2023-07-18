class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session   # 根本的な対策にはなっていない、後でこのメソッドを使わずにCSRF対策を行う
end
