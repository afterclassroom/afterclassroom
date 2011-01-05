# © Copyright 2009 AfterClassroom.com — All Rights Reserved
class BookType < ActiveRecord::Base
  # Relations
  has_many :post_books
end
