class Alcohol < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: 'ビール'},
    {id: 2, name: '焼酎'},
    {id: 3, name: 'ワイン'},
    {id: 4, name: 'ウィスキー'},
    {id: 5, name: 'その他'},
  ]
end