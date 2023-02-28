class Agendamento < ApplicationRecord
	validates :nome, presence: true, format: { with: /\A[a-zA-Z]+\s[a-zA-Z]+\z/ } #validar nome e sobrenome
	validates :hora, presence: true
	validates :servico, presence: true
	validates :telefone, presence: true

	belongs_to :user, optional: true 

end
