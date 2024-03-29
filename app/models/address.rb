class Address < ApplicationRecord  
  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  validates :prefecture, presence: true
  validates :postal_code, presence: { message: '入力してください' }
  validates :postal_code, length: { is: 7, message: 'フォーマットが正しくありません' }, if: ->(u) { u.postal_code.present? }
  validates :postal_code, numericality: { only_integer: true, message: '数字で入力してください' }, if: ->(u) { u.postal_code.present? }
  validates :prefecture, presence: { message: '選択してください' }
  validates :city, presence: { message: '入力してください' }
  validates :block, presence: { message: '入力してください' }
end
