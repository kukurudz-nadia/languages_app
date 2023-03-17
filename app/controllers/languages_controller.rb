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
    if language.nil?
      reversed_name = @search_query.split(" ").reverse.join(" ")
      @languages = Language.where("name ILIKE ?", reversed_name)
    end
  end
end
