class Servico < ApplicationRecord
validates :valor, presence: true
validates :servico, presence: true   
end
