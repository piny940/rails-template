class HomesController < ApplicationController
  def show
    p 'hoge'
    p ENV['GOOGLE_BUCKET']
  end
end
