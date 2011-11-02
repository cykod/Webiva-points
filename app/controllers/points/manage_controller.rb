class Points::ManageController < ModuleController
  include ActiveTable::Controller

  permit 'points_manage'

  component_info 'Points'

  cms_admin_paths 'content',
                  'Content'   => {:controller => '/content'},
                  'Types' => {:controller => 'admin', :action => 'types'},
                  'Users Points' => {:action => 'user_points'}

  active_table :user_points_table,
                PointsUser,
                [ hdr(:string, 'end_users.full_name'),
                  :points,
                  :created_at,
                  :updated_at
                ]
  
  def display_user_points_table(display=true)
    active_table_action 'point' do |act,ids|
    end

    @active_table_output = user_points_table_generate params, :order => 'points_user.created_at DESC', :joins => [:end_user, :point_type]

    render :partial => 'user_points_table' if display
  end
  
  def user_points
    cms_page_path ['Content'], 'Users Points'
    display_user_points_table false
  end
  
  active_table :transactions_table,
                PointsTransaction,
                [ hdr(:string, 'end_users.full_name'),
                  :amount,
                  :note,
                  :purchased,
                  :source,
                  :created_at,
                  :updated_at
                ]
  
  def display_transactions_table(display=true)
    @user_point ||= PointsUser.find(params[:path][0]) if params[:path][0]

    active_table_action 'transaction' do |act,ids|
    end

    conditions = @user_point ? ['point_transactions.end_user_id = ?', @user_point.end_user_id ] : nil
    @active_table_output = transactions_table_generate params, :conditions => conditions, :order => 'point_transactions.created_at DESC', :joins => [:end_user]

    render :partial => 'transactions_table' if display
  end
  
  def transactions
    @user_point = PointsUser.find(params[:path][0]) if params[:path][0]
    cms_page_path ['Content', 'Users Points'], 'Transactions'
    display_transactions_table false
  end
  
 end
