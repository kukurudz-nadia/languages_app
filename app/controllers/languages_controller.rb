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

  def search_by_type_or_designer
    @search_query = params[:type]
    if @search_query.nil?
      @languages = Language.where("type ILIKE ?", @search_query)
    else
      params_array = @search_query.split(" ")
      type, designed_by = match_param(params_array)

      negative_element = params_array.find { |elem| elem.match(/^-.+/) }
      if negative_element.nil?
        @languages = Language.where("type ILIKE ? AND designed_by ILIKE ?", "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%")
      else
        negative_search(negative_element, type, designed_by)
      end
    end
  end

  def match_param(params_array)
    type, designed_by = [], []
    params_array.each do |param|
      if Language.where("type ILIKE ?", "%#{param}%").any?
        type << param
      elsif Language.where("designed_by ILIKE ?", "%#{param}%").any?
        designed_by << param
      end
    end
    return type, designed_by
  end

  def negative_search(negative_element, type, designed_by)
    changed_neg_el = negative_element.gsub(/-/, "")

    if Language.where("type ILIKE ?", "%#{changed_neg_el}%").any?
      @languages = Language.where("type ILIKE ? AND designed_by ILIKE ? AND type NOT ILIKE ?", "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    elsif Language.where("designed_by ILIKE ?", "%#{changed_neg_el}%").any?
      @languages = Language.where("type ILIKE ? AND designed_by ILIKE ? AND designed_by NOT ILIKE ?", "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    end
  end
end
