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

    file_path = Rails.root.join('public', 'uploads', file.original_filename)
    FileUtils.mkdir_p(Rails.root.join('public', 'uploads')) unless File.directory?(Rails.root.join('public', 'uploads'))
    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end

    begin
      batch = Batch.create!(status: :pendente)
      CsvImportWorker.perform_async(batch.id, file_path)

      @message = "Boletos estão sendo processados e pagos em segundo plano!"
      redirect_to '/'
    rescue StandardError => e
      batch.destroy! if batch.persisted?
      @error = "Erro ao processar o arquivo: #{e.message}"
      render :create
    end
  end

end
