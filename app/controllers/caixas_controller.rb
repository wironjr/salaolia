class CaixasController < ApplicationController
  before_action :set_caixa, only: %i[ show edit update destroy ]

  # GET /caixas or /caixas.json
  def index
    @caixas = Caixa.all
  end

  # GET /caixas/1 or /caixas/1.json
  def show
  end

  # GET /caixas/new
  def new
    @caixa = Caixa.new
  end

  # GET /caixas/1/edit
  def edit
  end

  # POST /caixas or /caixas.json
  def create
    @caixa = Caixa.new(caixa_params)

    respond_to do |format|
      if @caixa.save
        format.html { redirect_to caixa_url(@caixa), notice: "Caixa was successfully created." }
        format.json { render :show, status: :created, location: @caixa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @caixa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /caixas/1 or /caixas/1.json
  def update
    respond_to do |format|
      if @caixa.update(caixa_params)
        format.html { redirect_to caixa_url(@caixa), notice: "Caixa was successfully updated." }
        format.json { render :show, status: :ok, location: @caixa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @caixa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /caixas/1 or /caixas/1.json
  def destroy
    @caixa.destroy

    respond_to do |format|
      format.html { redirect_to caixas_url, notice: "Caixa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caixa
      @caixa = Caixa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def caixa_params
      params.require(:caixa).permit(:nome_cliente, :data, :valor, :servico)
    end
end
