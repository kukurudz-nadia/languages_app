# This class provides search functionality for languages
class SearchService
  def initialize(search_query)
    @search_query = search_query
  end

  def search_by_name
    languages = Language.where("name ILIKE ?", @search_query)
    if languages.blank? && @search_query.present?
      reversed_name = @search_query.split.reverse.join(" ")
      languages = Language.where("name ILIKE ?", reversed_name)
    end
    languages
  end

  def search_type_or_designer
    if @search_query.present?
      type, designed_by = match_params(@search_query)
      negative_element = @search_query.split.find { |elem| elem.start_with?("-") }
      @languages = if negative_element.present?
                     negative_search(negative_element, type, designed_by)
                   else
                     search_by_type_designer(type, designed_by)
                   end
    else
      @languages = Language.none
    end
  end

  def match_params(params_array)
    type = []
    designed_by = []
    params_array.split.each do |param|
      if Language.where('type ILIKE ?', "%#{param}%").exists?
        type << param
      elsif Language.where('designed_by ILIKE ?', "%#{param}%").exists?
        designed_by << param
      end
    end
    [type, designed_by]
  end

  def negative_search(negative_element, type, designed_by)
    changed_neg_el = negative_element.delete_prefix("-")
    if Language.where('type ILIKE ?', "%#{changed_neg_el}%").exists?
      Language.where('type ILIKE ? AND designed_by ILIKE ?
                      AND type NOT ILIKE ?', "%#{type.join(' ')}%",
                     "%#{designed_by.join(' ')}%", "%#{changed_neg_el}%")
    elsif Language.where('designed_by ILIKE ?', "%#{changed_neg_el}%").exists?
      Language.where('type ILIKE ? AND designed_by ILIKE ?
                      AND designed_by NOT ILIKE ?', "%#{type.join(' ')}%",
                     "%#{designed_by.join(' ')}%", "%#{changed_neg_el}%")
    else
      Language.none
    end
  end

  def search_by_type_designer(type, designed_by)
    Language.where('type ILIKE ? AND designed_by ILIKE ?',
                   "%#{type.join(' ')}%", "%#{designed_by.join(' ')}%")
  end
end
