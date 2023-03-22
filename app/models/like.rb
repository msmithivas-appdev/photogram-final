class Like < ApplicationRecord

  validates(:user_id, { :presence => true })
  validates(:photo_id, { :presence => true })
  validates(:photo_id, { :uniqueness => { :scope => ["user_id"], :message => "already liked" } })
  
  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })
  belongs_to(:photo, { :required => true, :class_name => "Photo", :foreign_key => "photo_id", :counter_cache => true })



end
