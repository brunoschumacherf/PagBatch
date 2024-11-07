class BatchesController < ApplicationController
  require 'csv'
  def index
    @batches = Batch.all
  end

  def show
    @batch = Batch.find(params[:id])
    @boletos = @batch.boletos
  end

  def new
  end

  def create
    file = params[:file]

    if file.nil?
      @error = "Nenhum arquivo enviado"
      render :create and return
    end

    begin
      batch = Batch.create!(status: :pendente)

      CSV.foreach(file.path, headers: true) do |row|
        Boleto.create!(
          batch: batch,
          barcode: row["id"],
          valor: row["valor"],
          status: 'pendente'
        )
      end
      @message = "Boletos importados com sucesso!"
      redirect_to '/'
    rescue StandardError => e
      batch.destroy!
      @error = "Erro ao processar o arquivo: #{e.message}"
      render :create
    end
  end
end
