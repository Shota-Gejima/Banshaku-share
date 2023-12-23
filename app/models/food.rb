class Food < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: '肉系'},
    {id: 2, name: '水産物系'},
    {id: 3, name: '野菜系'},
    {id: 4, name: '乳製品'},
    {id: 5, name: '揚げ物'},
    {id: 6, name: '串焼き'},
    {id: 7, name: 'めん類'},
    {id: 8, name: 'ピザ'},
    {id: 9, name: '菓子類'},
    {id: 10, name: 'その他'},
  ]
  
end