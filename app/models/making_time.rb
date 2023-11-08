class MakingTime < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
  
  self.data = [
    {id: 1, name: '5分未満'},
    {id: 2, name: '10分未満'},
    {id: 3, name: '15分未満'},
    {id: 4, name: '20分未満'},
    {id: 5, name: '20分以上'},
  ]
end
