class DespesasController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_despesa, only: %i[ show edit update destroy ]

  # GET /despesas or /despesas.json
  def index
    @despesas = Despesa.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'") #do dia
  end

  # GET /despesas/1 or /despesas/1.json
  def show
  end

  # GET /despesas/new
  def new
    @despesa = Despesa.new
  end

  # GET /despesas/1/edit
  def edit
  end

  # POST /despesas or /despesas.json
  def create
    @despesa = Despesa.new(despesa_params)
    @despesa.valor = @despesa.valor.gsub('R$','').gsub('.','').gsub(',','.').gsub(' ', '')
    if @despesa.save
      flash[:success] = "Despesa criada com sucesso!" 
      redirect_to servicos_do_dia_servicos_path
    else
      render 'new'
    end
end
   

  # PATCH/PUT /despesas/1 or /despesas/1.json
  def update
    if @despesa.update(despesa_params)
      flash[:success] = "Despesa editada com sucesso!" 
      redirect_to servicos_do_dia_servicos_path
    else
      render 'new'
    end
   
  end

  # DELETE /despesas/1 or /despesas/1.json
  def destroy
    @despesa.destroy

    flash[:success] = "Despesa apagada com sucesso!" 
    redirect_to servicos_do_dia_servicos_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_despesa
      @despesa = Despesa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def despesa_params
      params.require(:despesa).permit(:descricao, :valor, :data)
    end
end
