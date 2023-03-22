class Comment < ApplicationRecord

  validates(:photo_id, { :presence => true })
  validates(:commenter_id, { :presence => true })
  validates(:body, { :presence => true })

  belongs_to(:commenter, { :required => true, :class_name => "User", :foreign_key => "commenter_id", :counter_cache => true })
  belongs_to(:photo, { :required => true, :class_name => "Photo", :foreign_key => "photo_id", :counter_cache => true })

end
