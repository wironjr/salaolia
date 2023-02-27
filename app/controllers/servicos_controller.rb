class ServicosController < ApplicationController
  before_action :require_logged_in_user#, except: [:index] 
  before_action :set_servico, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /servicos or /servicos.json
  def index
    @servicos = Servico.all
    
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
    
    if params[:nome_search] || params[:servico_search] || params[:data_search]
      @servicos = @servicos.where('nome_cliente ILIKE ?', "%#{params[:nome_search]}%") if params[:nome_search].present?
      @servicos = @servicos.where('servico ILIKE ?', "%#{params[:servico_search]}%") if params[:servico_search].present?
      if params[:data_search].present?
        params[:data_search] = Date.parse(params[:data_search]).strftime("%Y-%m-%d")
        @servicos = @servicos.where('CAST(data AS TEXT) LIKE ?', "%#{params[:data_search]}%")
      end
    else
      @servicos = Servico.all.order(data: :desc)
    end
    
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum
    @pagy, @servicos = pagy(@servicos)
  end

  def caixa_total
    @servicos = Servico.all
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum
  end

  def servicos_do_dia
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")

    
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
    
    @despesas = Despesa.all
    @despesas_valor = @despesas.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").map(&:valor_real).sum
    
    @caixa_total_dia = @valor_total_dia - @despesas_valor

    if params[:nome_search] || params[:servico_search]
      @servicos_do_dia = @servicos_do_dia.where('nome_cliente ILIKE ?', "%#{params[:nome_search]}%") if params[:nome_search].present?
      @servicos_do_dia = @servicos_do_dia.where('servico ILIKE ?', "%#{params[:servico_search]}%") if params[:servico_search].present?
    else
      @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").order(created_at: :desc)
    end

    @pagy, @servicos_do_dia = pagy(@servicos_do_dia)
  end

  # GET /servicos/1 or /servicos/1.json
  def show
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
    
    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]

    @servicos_prestados = []
    
    @servicos.each do |servico|
      servico_valor = servico.split
      servico_valor = servico_valor.last.gsub("R$", "").gsub(",","")

      servico = servico.gsub(/\-.+/, "")
      
      @servicos_prestados << servico
      
      if params[:servico2].present?
        @servico_valor = servico_valor if params[:servico2].gsub(/\-.+/, "") == servico
      end
      
    end
  end

  # GET /servicos/1/edit
  def edit
    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]

    @servicos_prestados = []
    @servicos.each do |servico|
      @servicos_prestados << servico.gsub(/\-.+/, "")
    end
  end

  # POST /servicos or /servicos.json
  def create
    @servico = Servico.new(servico_params)
    @servico.valor = @servico.valor.gsub('R$','').gsub('.','').gsub(',','.').gsub(' ', '')

    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]

    @servicos_prestados = []
    @servicos.each do |servico|
      @servicos_prestados << servico.gsub(/\-.+/, "")
    end

    if Servico.where(nome_cliente: params[:servico][:nome_cliente]).where(servico: params[:servico][:servico]).present? && Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").present?
      flash[:danger] = "Serviço já cadastrado!" 
      redirect_to servicos_do_dia_servicos_path
    else
      if @servico.save
        flash[:success] = "Serviço criado com sucesso!" 
        redirect_to servicos_do_dia_servicos_path
      else
        render 'new'
      end
    end
  end

  # PATCH/PUT /servicos/1 or /servicos/1.json
  def update
    params[:servico][:valor] = params[:servico][:valor].gsub('R$','').gsub('.','').gsub(',','.').gsub(' ', '')

    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]

    @servicos_prestados = []
    @servicos.each do |servico|
      @servicos_prestados << servico.gsub(/\-.+/, "")
    end
    
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
