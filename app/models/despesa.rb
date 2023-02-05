class Despesa < ApplicationRecord
validates :valor, presence: true
validates :descricao, presence: true  
end
