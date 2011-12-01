
class Points::Trigger < Trigger::TriggeredActionHandler

  def self.trigger_actions_handler_info
    { :name => 'Points Triggered Actions' }
  end  

  register_triggered_actions [
    { :name => :add_points,
      :description => 'Add Points to a user',
      :options_partial => '/points/trigger/add_points'
    }
  ]

  class AddPointsTrigger < Trigger::TriggerBase #:nodoc:

    include ActionView::Helpers::TextHelper

    class AddPointsOptions < HashModel
      attributes :source => nil, :note => nil, :amount => 1
      validates_presence_of :amount

      integer_options :amount

      validates_numericality_of :amount

    end
    
    options "Add Points Options", AddPointsOptions

    def perform(data={},user = nil)
      @data = data
    
      if user && user.id
        points_user = PointsUser.push_user user
        points_user.add_points options.amount, :note => options.note, :source => options.source
      end
    end

  end
end
