class Agendamento < ApplicationRecord
	validates :nome, presence: true
	validates :hora, presence: true
	validates :data, presence: true
	validates :servico, presence: true
	validates :telefone, presence: true
end
