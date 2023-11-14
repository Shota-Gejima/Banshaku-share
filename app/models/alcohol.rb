class Alcohol < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: 'ビール'},
    {id: 2, name: '焼酎'},
    {id: 3, name: '日本酒'},
    {id: 4, name: '梅酒'},
    {id: 5, name: 'ワイン'},
    {id: 6, name: 'サワー'},
    {id: 7, name: 'ウイスキー'},
    {id: 8, name: 'ブランデー'},
    {id: 9, name: 'その他'}
  ]
end