class AgendamentosController < ApplicationController
  before_action :require_logged_in_user, except: [ :new, :create, :json_teste ]
  before_action :set_agendamento, only: %i[ show edit update destroy ]
  include Pagy::Backend


  # GET /agendamentos or /agendamentos.json
  def index
    @agendamentos = current_user.agendamentos
    
    @agendamentos_dia = @agendamentos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").sort_by { |obj| obj.hora.to_i }
    
    @qnt_agendamentos = @agendamentos_dia.count

    @qnt_agendamentos_futuros = @agendamentos.where("to_char(data,'YYYY-MM-DD') > '#{Time.now.to_date.to_s}'").count

    @servico = Servico.all
  end

  def todos
    @agendamentos = Agendamento.all.order(data: :desc)
    @pagy, @agendamentos = pagy(@agendamentos)
  end

  def futuros
    @agendamentos = current_user.agendamentos.where("to_char(data,'YYYY-MM-DD') > '#{Time.now.to_date.to_s}'").order(data: :desc)
  end

  def json_teste   
    @agendamentos = Agendamento.where(data: params[:data])
    render json: JSON.parse(@agendamentos.to_json)
  end

  # GET /agendamentos/1 or /agendamentos/1.json
  def show
  end

  # GET /agendamentos/new
  def new
    @agendamento = Agendamento.new
    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]
  end

  # GET /agendamentos/1/edit
  def edit
     @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]
    
  end

  # POST /agendamentos or /agendamentos.json
  def create
    @agendamento = current_user.agendamentos.build(agendamento_params)
    @agendamento.telefone = @agendamento.telefone.gsub('(','').gsub(')','').gsub(' ','').gsub('-','')

    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]
    
    if Agendamento.where(hora: params[:agendamento][:hora]).where(data: params[:agendamento][:data]).present?
      flash[:danger] = "Horário indisponível."
      redirect_to new_agendamento_path
    elsif params[:agendamento][:hora] == "Sem hora dispónivel"
      flash[:danger] = "Sem hora dispónivel para o dia selecionado."
      render 'new'
    else
      if @agendamento.save
        flash[:success] = "Agendamento criado com sucesso!"
        redirect_to new_agendamento_path
      else
        render 'new'
      end
    end
  end
    
    

  # PATCH/PUT /agendamentos/1 or /agendamentos/1.json
  def update
    @agendamento.telefone = @agendamento.telefone.gsub('(','').gsub(')','').gsub(' ','').gsub('-','')
    
    @servicos = ["Escova Inteligente - R$100,00", "Escova Orgânica - R$100,00", 
    "Botox - R$80,00", "Hidratação - R$40,00", "Hidratação com Escova - R$60,00","Coloração - R$30,00", "Coloração com Escova - R$45,00",
    "Escova - R$25,00","Prancha - R$25,00","Escova com Prancha - R$35,00","Pé e mão - R$35,00","Mão - R$20,00","Pé - R$20,00","Spa dos pés - R$60,00",
    "Blindagem - R$50,00", "Banho de gel - R$40,00","Unhas postiças - R$40,00", "Unhas acrílico - R$100,00","Manutenção acrílico - R$80,00"]
    
    if @agendamento.update(agendamento_params)
      flash[:success] = "Agendamento editado com sucesso!" 
      redirect_to agendamentos_path
    else
      render 'new'
    end
    
  end

  # DELETE /agendamentos/1 or /agendamentos/1.json
  def destroy
    @agendamento.destroy
    flash[:success] = "Agendamento apagado com sucesso!" 
    redirect_to agendamentos_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agendamento
      @agendamento = current_user.agendamentos.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agendamento_params
      params.require(:agendamento).permit(:data, :hora, :nome, :servico, :telefone)
    end
end
