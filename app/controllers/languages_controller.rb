class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end
  def show
    @language = Language.find(params[:id])
  end

  def search_by_name
    @search_query = params[:name]
    @languages = Language.where(name: @search_query)
  end
end
