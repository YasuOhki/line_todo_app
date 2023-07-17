class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    binding.pry
  end
end
