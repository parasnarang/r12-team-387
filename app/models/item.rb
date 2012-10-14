# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  price       :string(255)      not null
#  image_url   :string(255)
#  product_url :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  board_id    :integer
#  user_id     :integer
#

class Item < ActiveRecord::Base
  attr_accessible :image_url, :name, :price, :product_url, :votes, :board_id, :new_board
  belongs_to :board
  belongs_to :user

  has_reputation :votes, source: :user, aggregated_by: :sum
end
