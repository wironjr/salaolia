class Agendamento < ApplicationRecord
	validates :nome, presence: true
	validates :hora, presence: true
	validates :servico, presence: true
	validates :telefone, presence: true

	belongs_to :user

end
