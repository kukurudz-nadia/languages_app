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

  def search_by_type_or_designer
    @search_query = params[:type]
    params_array = @search_query.split(" ")
    type, designed_by = [], []
    params_array.each do |param|
      if Language.where("type ILIKE ?", "%#{param}%").any?
        type << param
      elsif Language.where("designed_by ILIKE ?", "%#{param}%").any?
        designed_by << param
      end
    end
    negative_element = params_array.find { |elem| elem.match(/^-.+/) }
    byebug
    changed_neg_el = negative_element.gsub(/-/, "")
    if Language.where("type ILIKE ?", "%#{changed_neg_el}%").any?
      @languages = Language.where("type ILIKE ? AND designed_by ILIKE ? AND type NOT LIKE ?", "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    elsif Language.where("designed_by ILIKE ?", "%#{changed_neg_el}%").any?
      @languages = Language.where("type ILIKE ? AND designed_by ILIKE ? AND designed_by NOT LIKE ?", "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    end
      byebug

  end
end
