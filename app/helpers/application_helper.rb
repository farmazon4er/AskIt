module ApplicationHelper
  include Pagy::Frontend

  def currently_at(current_page = "")
    render partial: 'shared/menu', locals: {current_page: current_page}

  end

  def full_title(page = "")
    base_title = "AskIt"
    if page.present?
      base_title + ' | ' + page
    else
      base_title
    end
  end

  def nav_tab(title, url, option = {})
    current_page = option.delete(:current_page)
    css = current_page == title ? 'text-secondary' : 'text-white'

    option[:class] = if option[:class]
                       option[:class] + ' ' + css
                     else
                       css
                     end
    link_to title, url, option
  end

  def pagination(obj)
    raw(pagy_bootstrap_nav obj) if obj.pages > 1
  end
end
