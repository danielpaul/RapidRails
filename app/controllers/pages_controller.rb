class PagesController < ApplicationController
  include HighVoltage::StaticPage

  caches_page :show

  def show
    super
  end
end