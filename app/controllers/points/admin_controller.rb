
class Points::AdminController < ModuleController

  component_info 'Points', :description => 'User Points support', 
                              :access => :private
                              
  # Register a handler feature
  register_permission_category :points, "Points" ,"Permissions related to Points"
  
  register_permissions :points, [ [ :manage, 'Manage Points', 'Manage Points' ],
                                  [ :config, 'Configure Points', 'Configure Points' ]
                                  ]
  cms_admin_paths "options",
     "Points Options" => { :action => 'index' },
     "Options" => { :controller => '/options' },
     "Modules" => { :controller => '/modules' }

  permit 'points_config'

  register_handler :user_segment, :fields, 'Points::UserSegmentField'
  register_handler :members, :view,  "Points::ManageUserController"
  register_handler :trigger, :actions, 'Points::Trigger'

  register_handler :mailing, :view, "Points::MailingHandler"
  register_handler :mailing, :link, "Points::MailingHandler"

  public 
 
  def options
    cms_page_path ['Options','Modules'],"Points Options"
    
    @options = self.class.module_options(params[:options])
    
    if request.post? && @options.valid?
      Configuration.set_config_model(@options)
      flash[:notice] = "Updated Points module options".t 
      redirect_to :controller => '/modules'
      return
    end    
  
  end
  
  def self.module_options(vals=nil)
    Configuration.get_config_model(Options,vals)
  end
  
  class Options < HashModel
    attributes :open_email_points => 0, :open_email_source => 'Mailing View', :link_email_points => 0, :link_email_source => "Mailing Link"

    validates_numericality_of :open_email_points
    validates_numericality_of :link_email_points

    integer_options :open_email_points, :link_email_points
  
  end

end
