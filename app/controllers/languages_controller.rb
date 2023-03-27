class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end

  def show
    @language = Language.find(params[:id])
  end

  def search_by_name
    @search_query = params[:name]
    @languages = SearchService.new(@search_query).search_by_name
  end

  def search_by_type_or_designer
    @search_query = params[:type]
    @languages = SearchService.new(@search_query).search_type_or_designer
  end
end
