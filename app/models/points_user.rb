class PointsUser < DomainModel
  validates_presence_of :end_user_id 

  has_end_user :end_user_id
  has_many :points_transactions

  def add_points(amount,options)
    self.commit_transaction(self.points_transactions.build(
      {:amount => amount}.merge(options)
    ))
  end

  def self.push_user(user)
    self.find_by_end_user_id(user.id) || PointsUser.create(:end_user_id => user.id)
  end

  def commit_transaction(transaction)
    self.points += transaction.amount
    transaction.save && self.save
  end

end