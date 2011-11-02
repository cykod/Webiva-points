
class Points::ManageUserController < ModuleController
  include ActiveTable::Controller

  permit 'credits_manage'

  component_info 'Points'

  def self.members_view_handler_info
    {
      :name => 'Points',
      :controller => '/points/manage_user',
      :action => 'view'
    }
   end

  # need to include
  active_table :transactions_table,
                PointsTransaction,
                [ :amount,
                  :note,
                  "Admin User",
                  :source,
                  :created_at,
                  :updated_at
                ]

  public

  def display_transactions_table(display=true)
    @user ||= EndUser.find params[:path][0]
    @tab ||= params[:tab]

    active_table_action 'transaction' do |act,ids|
    end

    @points_user = PointsUser.push_user @user 
    
    @active_table_output = transactions_table_generate params, :conditions => ['points_transactions.end_user_id = ?', @user.id], :order => 'created_at DESC'

    render :partial => 'transactions_table' if display
  end

  def view
    @user = EndUser.find params[:path][0]
    @tab = params[:tab]
    display_transactions_table(false)
    render :partial => 'view'
  end

  def transaction
    @user = EndUser.find params[:path][0]
    @tab = params[:tab]
    @transaction = PointsTransaction.new

    if request.post? && params[:transaction]
      points_user = PointsUser.push_user @user
      @transaction = points_user.points_transactions.new params[:transaction]
      @transaction.note =  "[Administrative]" if @transaction.note.blank?
      @transaction.attributes = { :admin_user_id => myself.id,
        :source => 'admin' }

      if params[:commit] && @transaction.valid?
        points_user.commit_transaction @transaction

        render :update do |page|
          page << 'PointsData.viewTransactions();'
        end
        return
      end
    end

    render :partial => 'transaction'
  end
end
