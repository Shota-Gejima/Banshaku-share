class Food < ActiveHash::Base
  include ActiveHash::Associations
  has_many :recipes
    
  self.data = [
    {id: 1, name: '---' },
    {id: 2, name: '肉系'},
    {id: 3, name: '魚系'},
    {id: 4, name: '野菜系'},
    {id: 5, name: '乳製品系'},
    {id: 6, name: 'その他'},
  ]
end