class LanguagesController < ApplicationController
  def index
    @languages = Language.all
  end

  def show
    @language = Language.find(params[:id])
  end

  def search_by_name
    @search_query = params[:name]
    @languages = Language.search_by_name(@search_query)
  end

  def search_by_type_or_designer
    @search_query = params[:type]
    if @search_query.present?
      type, designed_by = Language.match_params(@search_query.split)
      negative_element = params[:type].split.find { |elem| elem.start_with?("-") }
      if negative_element.present?
        @languages = Language.negative_search(negative_element, type, designed_by)
      else
        @languages = Language.search_by_type_and_designed_by(type, designed_by)
      end
    else
      @languages = Language.none
    end
  end
end
