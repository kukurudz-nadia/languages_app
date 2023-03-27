class Language < ApplicationRecord
  self.inheritance_column = :_type_disabled

  def self.search_by_name(query)
    languages = where("name ILIKE ?", query)
    language = languages.first
    if languages.blank? && query.present?
      reversed_name = query.split.reverse.join(" ")
      languages = where("name ILIKE ?", reversed_name)
    end
    languages
  end

  def self.match_params(params_array)
    type, designed_by = [], []
    params_array.each do |param|
      if where("type ILIKE ?", "%#{param}%").exists?
        type << param
      elsif where("designed_by ILIKE ?", "%#{param}%").exists?
        designed_by << param
      end
    end
    return type, designed_by
  end

  def self.negative_search(negative_element, type, designed_by)
    changed_neg_el = negative_element.delete_prefix("-")
    if where("type ILIKE ?", "%#{changed_neg_el}%").exists?
      where("type ILIKE ? AND designed_by ILIKE ?
            AND type NOT ILIKE ?", "%#{type.join(" ")}%",
           "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    elsif where("designed_by ILIKE ?", "%#{changed_neg_el}%").exists?
      where("type ILIKE ? AND designed_by ILIKE ?
            AND designed_by NOT ILIKE ?", "%#{type.join(" ")}%",
            "%#{designed_by.join(" ")}%", "%#{changed_neg_el}%")
    else
      none
    end
  end

  def self.search_by_type_and_designed_by(type, designed_by)
    where("type ILIKE ? AND designed_by ILIKE ?",
          "%#{type.join(" ")}%", "%#{designed_by.join(" ")}%")
  end
end
