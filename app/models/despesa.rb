class Despesa < ApplicationRecord
validates :valor_real, presence: true
validates :descricao, presence: true  
end
