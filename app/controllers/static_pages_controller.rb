class StaticPagesController < ApplicationController
	before_action :require_logged_in_user

	def index
		@nome = "Wiron"
		@servicos = Servico.all
    	@valor_total = @servicos.map(&:valor).map(&:to_f).sum
		@servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    	@valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum

		@despesas = Despesa.all
		@despesas_valor = @despesas.map(&:valor).map(&:to_f).sum
		@despesas_do_dia = @despesas.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").sum(:valor_real)
	
		@valor_total_lucro = @valor_total - @despesas_valor

		@agendamentos = Agendamento.all
		@qnt_agendamentos_dia = @agendamentos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").count
		@qnt_agendamentos_futuros = @agendamentos.where("to_char(data,'YYYY-MM-DD') > '#{Time.now.to_date.to_s}'").count
		
		
	end

	def financeiro
		
		@servicos = Servico.all
		@despesas = Despesa.all
		@servicos_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
		@servicos_mes_count = @servicos_mes.count
		

		@despesas_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
		@servicos_mes_valor = @servicos_mes.map(&:valor).map(&:to_f).sum
		@despesas_mes_valor = @despesas_mes.sum(&:valor_real)
		@lucro_mes = @servicos_mes_valor - @despesas_mes_valor

#binding.pry

		@servicos_mes_ticket = @servicos_mes_valor / @servicos_mes_count unless @servicos_mes_count == 0

		if params[:data_search].present?
			@mes = params[:data_search]
			ano = @mes.split("-")[0].to_i
			mes = @mes.split("-")[1].to_i
			@servicos_mes = @servicos.where("DATE_PART('year', data) = ? AND DATE_PART('month', data) = ?", ano, mes)
			@despesas_mes = @despesas.where("DATE_PART('year', data) = ? AND DATE_PART('month', data) = ?", ano, mes)
			@servicos_mes_valor = @servicos_mes.map(&:valor).map(&:to_f).sum
			@despesas_mes_valor = @despesas_mes.sum(&:valor_real)
			@lucro_mes = @servicos_mes_valor - @despesas_mes_valor
			@servicos_mes_count = @servicos_mes.count

			if @servicos_mes_count == 0
				@servicos_mes_ticket = 0
			else
				@servicos_mes_ticket = @servicos_mes_valor / @servicos_mes_count
			end 



		end
	end

end
