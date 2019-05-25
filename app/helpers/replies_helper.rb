module RepliesHelper
  def link_to_filter(name)
    title = name.titleize
    
    if @filter != name
      link_to(title, replies_path(filter: name))
    else
      title
    end
  end

     def is_unread?(comment)
             if !@user || !@ribbon
                       return false
                           end

                  (comment.created_at > @ribbon.updated_at) && (comment.user_id != @user.id)
                    end

end

