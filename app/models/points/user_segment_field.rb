
class Points::UserSegmentField < UserSegment::FieldHandler
  extend ActionView::Helpers::NumberHelper

  def self.user_segment_fields_handler_info
    {
      :name => 'Points Fields',
      :domain_model_class => PointsUser
    }
  end

 register_field :points_total, UserSegment::CoreType::SimpleNumberType, :field => :points, :name => 'Points', :sortable => true


   def self.get_handler_data(ids, fields)
    PointsUser.find(:all, :conditions => {:end_user_id => ids}).group_by(&:end_user_id)
  end

  def self.field_output(user, handler_data, field)
    UserSegment::FieldType.field_output(user, handler_data, field)
  end

end
