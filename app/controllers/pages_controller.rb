class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout "application_landing_page"
  
  caches_page :show
  
  def show
    super
  end
end