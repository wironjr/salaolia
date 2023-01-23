class StaticPagesController < ApplicationController
   
	def index
		@nome = "Wiron"
		@servicos = Servico.all
    	@valor_total = @servicos.map(&:valor).map(&:to_f).sum
		@servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    	@valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
	end

end
