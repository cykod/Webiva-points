

class Points::MailingHandler

  def self.mailing_link_handler_info 
    { :name => 'Points Mailing Handlers' }
  end

  def self.mailing_view_handler_info 
    { :name => 'Points Mailing Handlers' }
  end

  def mailing_link(user)
    opts = Points::AdminController.module_options
    if opts.link_email_points > 0
      points_user = PointsUser.push_user user
      points_user.add_points opts.link_email_points, :source => opts.link_email_source
    end
  end

  def mailing_view(user)
    opts = Points::AdminController.module_options
    if opts.open_email_points > 0
      points_user = PointsUser.push_user user
      points_user.add_points opts.open_email_points, :source => opts.open_email_source
    end
  end

end
