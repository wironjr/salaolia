class ServicosController < ApplicationController
  before_action :set_servico, only: %i[ show edit update destroy ]

  # GET /servicos or /servicos.json
  def index
    @servicos = Servico.all.order(data: :desc)
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum
  end

  def caixa_total
    @servicos = Servico.all
    @valor_total = @servicos.map(&:valor).map(&:to_f).sum
  end

  def servicos_do_dia
    @servicos_do_dia = Servico.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").order(created_at: :desc)
    @valor_total_dia = @servicos_do_dia.map(&:valor).map(&:to_f).sum
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

    respond_to do |format|
      if @servico.save
        format.html { redirect_to servicos_do_dia_servicos_path, notice: "Serviço criado com sucesso!" }
        format.json { render :show, status: :created, location: @servico }
      else
        format.html { redirect_to new_servico_path, notice: "Campos de SERVIÇO e VALOR são obrigatórios!" }
        format.json { render json: @servico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servicos/1 or /servicos/1.json
  def update
    respond_to do |format|
      if @servico.update(servico_params)
        format.html { redirect_to servicos_do_dia_servicos_path, notice: "Serviço atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @servico }
      else
        format.html { redirect_to new_servico_path, notice: "Campos de SERVIÇO e VALOR são obrigatórios!" }
        format.json { render json: @servico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servicos/1 or /servicos/1.json
  def destroy
    @servico.destroy

    respond_to do |format|
      format.html { redirect_to servicos_url, notice: "Serviço apagado com sucesso!" }
      format.json { head :no_content }
    end
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
