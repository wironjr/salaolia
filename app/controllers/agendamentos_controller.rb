class AgendamentosController < ApplicationController
  before_action :require_logged_in_user, except: [ :new, :create, :json_teste ] 


  # GET /agendamentos or /agendamentos.json
  def index
    @agendamentos = Agendamento.all
    @agendamentos_dia = Agendamento.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    @qnt_agendamentos = @agendamentos_dia.count
    
  end

  def todos
    @agendamentos = Agendamento.all.order(data: :desc)
  end

  def futuros
    @agendamentos = Agendamento.where("to_char(data,'YYYY-MM-DD') > '#{Time.now.to_date.to_s}'").order(data: :desc)
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
  end

  # GET /agendamentos/1/edit
  def edit
  end

  # POST /agendamentos or /agendamentos.json
  def create
    @agendamento = Agendamento.new(agendamento_params)
    @agendamento.telefone = @agendamento.telefone.gsub('(','').gsub(')','').gsub(' ','').gsub('-','')
    
    if Agendamento.where(hora: params[:agendamento][:hora]).where(data: params[:agendamento][:data]).present?
      flash[:danger] = "Horário indisponível."
      redirect_to new_agendamento_path
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
   
    if @agendamento.update(agendamento_params)
      flash[:success] = "Agendamento editado com sucesso!" 
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
      @agendamento = Agendamento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agendamento_params
      params.require(:agendamento).permit(:data, :hora, :nome, :servico, :telefone)
    end
end
