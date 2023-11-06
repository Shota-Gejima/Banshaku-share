class Alcohol < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: '---' },
    {id: 2, name: 'ビール'},
    {id: 3, name: '焼酎'},
    {id: 4, name: 'ワイン'},
    {id: 5, name: 'ウィスキー'},
    {id: 6, name: 'その他'},
  ]
end