class MakingTime < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
  
  self.data = [
    {id: 1, name: '5分'},
    {id: 2, name: '10分'},
    {id: 3, name: '15分'},
    {id: 4, name: '20分'},
    {id: 5, name: '20分以上'},
  ]
  
end