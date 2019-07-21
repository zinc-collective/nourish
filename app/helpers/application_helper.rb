module ApplicationHelper

  def field_name_attribute(object, field)
    "#{sanitized_object_name(object)}[#{sanitized_field_name(field)}]"
  end

  def stripe_connect_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_FThWZ8to7Rystw7UH6toHaZyAVvtmwEn&scope=read_write"
  end

  private def sanitized_object_name(object)
    object.model_name.to_s.downcase.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  private def sanitized_field_name(field_name)
    field_name.to_s.gsub(':','').sub(/\?$/, "")
  end
end
