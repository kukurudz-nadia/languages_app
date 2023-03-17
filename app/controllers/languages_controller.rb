class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end
  def show
    @language = Language.find(params[:id])
  end

  def search_by_name
    @search_query = params[:name]
    @languages = Language.where("name ILIKE ?", @search_query)
    language = @languages.first
    if language.nil? && !@search_query.nil?
      reversed_name = @search_query.split(" ").reverse.join(" ")
      @languages = Language.where("name ILIKE ?", reversed_name)
    end
  end

  def search_by_designer
    @search_query = params[:designed_by]
    @languages = Language.where("designed_by ILIKE ?", "%#{@search_query}%")
  end

  def search_by_type
    @search_query = params[:type]
    @languages = Language.where("type ILIKE ?", "%#{@search_query}%")
  end
end
