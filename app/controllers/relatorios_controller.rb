class RelatoriosController < ApplicationController
	before_action :require_logged_in_user

	def servicos
		@nome = "Wiron"
		
		@servico_mais_usado = Servico.group(:servico).order('count_id DESC').limit(1).count(:id).keys.first
		@servico = Servico.group(:servico).count
	end

	def despesas
		@despesa_mais_usada = Despesa.group(:descricao).order('count_id DESC').limit(1).count(:id).keys.first
		@despesas = Despesa.group(:descricao).sum(:valor_real)
	end

	def lucro_mes
		servicos_do_mes = Servico.where(data: [Time.now.beginning_of_month..Time.now.end_of_month]).map(&:valor).map(&:to_f).to_a
    
		#@valor_total_mes = @servicos_do_mes.map(&:valor).map(&:to_f).sum
		
		@despesas = Despesa.all

		despesas_valor_mes = Despesa.where(data: [Time.now.beginning_of_month..Time.now.end_of_month]).map(&:valor_real).map(&:to_f).to_a
			
		@chart_data = { servico: servicos_do_mes, despesa: despesas_valor_mes }

		@lucro_mes = Servico.where(data: [Time.now.beginning_of_month..Time.now.end_of_month]).map(&:valor).map(&:to_f).sum - Despesa.where(data: [Time.now.beginning_of_month..Time.now.end_of_month]).sum(&:valor_real)

	end

end
