class ServicosController < ApplicationController
  before_action :require_logged_in_user#, except: [:index] 
  before_action :set_servico, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /servicos or /servicos.json
  def index
    @servicos = Servico.all.order(data: :desc)
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum

    @pagy, @servicos = pagy(@servicos)
  end

  def caixa_total
    @servicos = Servico.all
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum
  end

  def servicos_do_dia
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").order(created_at: :desc)
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
    
    @despesas = Despesa.all
    @despesas_valor = @despesas.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").map(&:valor).map(&:to_f).sum
  
    @caixa_total_dia = @valor_total_dia - @despesas_valor
  end

  # GET /servicos/1 or /servicos/1.json
  def show
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
  end

  # GET /servicos/1/edit
  def edit
  end

  # POST /servicos or /servicos.json
  def create
    @servico = Servico.new(servico_params)
    @servico.valor = @servico.valor.gsub('R$','').gsub('.','').gsub(',','.').gsub(' ', '')

    if @servico.save
      flash[:success] = "Serviço criado com sucesso!" 
      redirect_to servicos_do_dia_servicos_path
    else
      render 'new'
    end
  end

  # PATCH/PUT /servicos/1 or /servicos/1.json
  def update
    
    if @servico.update(servico_params)
      flash[:success] = "Serviço atualizado com sucesso!" 
      redirect_to servicos_do_dia_servicos_path
    else
      render 'new'
    end

  end

  # DELETE /servicos/1 or /servicos/1.json
  def destroy
    @servico.destroy
    
    flash[:success] = "Serviço apagado com sucesso!" 
    redirect_to servicos_do_dia_servicos_path
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_servico
      @servico = Servico.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def servico_params
      params.require(:servico).permit(:data, :nome_cliente, :servico, :valor)
    end
end
