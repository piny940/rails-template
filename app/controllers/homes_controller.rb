class HomesController < ApplicationController
  def show
    p 'hoge'
    p ENV['GOOGLE_BUCKET']
    p ENV['PATH']
    p ENV['RAILS_ENV']
    p ENV['USER']
    p ENV['BUNDLE_GEMFILE']
  end
end
