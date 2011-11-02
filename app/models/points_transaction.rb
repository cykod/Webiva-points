class PointsTransaction < DomainModel
  belongs_to :points_user
  has_end_user :end_user_id
  
  has_end_user :admin_user_id 
  validates_presence_of :amount
  validates_presence_of :points_user
  
  before_create :set_defaults

  def self.by_user(user)
    self.where(:end_user_id => user.id)
  end

  def set_defaults
    self.end_user_id = self.points_user.end_user_id if self.points_user
  end
end
