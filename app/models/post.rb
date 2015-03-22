class Post < ActiveRecord::Base
  # associations

  #validation
  validates_presence_of :title, :content, :link
end
