# This class provides search functionality for languages
class SearchService
  def self.search_by_name(query)
    languages = Language.where("name ILIKE ?", query)
    if languages.blank? && query.present?
      reversed_name = query.split.reverse.join(" ")
      languages = Language.where("name ILIKE ?", reversed_name)
    end
    languages
  end

  def self.match_params(params_array)
    type = []
    designed_by = []
    params_array.split.each do |param|
      if Language.where('type ILIKE ?', "%#{param}%").exists?
        type << param
      elsif Language.where('designed_by ILIKE ?', "%#{param}%").exists?
        designed_by << param
      end
    end
    result = []
    result << type
    result << designed_by
    result
  end

  def self.negative_search(negative_element, type, designed_by)
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

  def self.search_by_type_designer(type, designed_by)
    Language.where('type ILIKE ? AND designed_by ILIKE ?',
                   "%#{type.join(' ')}%", "%#{designed_by.join(' ')}%")
  end
end
