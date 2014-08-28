module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Auction"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

=begin
  def admin?(user)
    if not user.nil?
      return user.admin
    end
    return false
  end
=end
  
 
  
  
end
