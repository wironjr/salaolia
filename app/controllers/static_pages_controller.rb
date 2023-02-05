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
	
		@valor_total_lucro = @valor_total - @despesas_valor
	end

end
