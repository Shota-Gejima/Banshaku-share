class MakingTime < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
  
  self.data = [
    {id: 1, name: '---' },
    {id: 2, name: '5分未満'},
    {id: 3, name: '10分未満'},
    {id: 4, name: '15分未満'},
    {id: 5, name: '15分以上'},
  ]
end
