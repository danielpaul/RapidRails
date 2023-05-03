module ApplicationHelper
  include Pagy::Frontend

  # Method used for turbo frame dom with hashid instead of record id
  def dom_hashid(record, prefix = nil)
    if (record_id = record.hashid)
      "#{dom_class(record, prefix)}_#{record_id}"
    else
      dom_class(record, prefix || NEW)
    end
  end
end
