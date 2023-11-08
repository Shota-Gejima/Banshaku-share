class Food < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: '肉系'},
    {id: 2, name: '魚系'},
    {id: 3, name: '野菜系'},
    {id: 4, name: '乳製品系'},
    {id: 5, name: 'その他'},
  ]
end