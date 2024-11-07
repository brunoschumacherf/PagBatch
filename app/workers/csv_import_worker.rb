require 'csv'

class CsvImportWorker
  include Sidekiq::Worker

  def perform(batch_id, file_path)
    batch = Batch.find(batch_id)

    begin
      puts "Iniciando o processamento do arquivo CSV"
      file = File.open(file_path, 'r')

      CSV.foreach(file, headers: true) do |row|
        boleto = Boleto.create!(
          batch: batch,
          barcode: row["id"],
          valor: row["valor"],
          status: 'pendente'
        )
        puts "Boleto criado para o barcode #{boleto.barcode}"
      end
      batch.boletos.each do |boleto|
        PaymentProcessingWorker.perform_async(boleto.id)
      end

      batch.update!(status: :processado)
      file.close if file
      delete_file(file_path)
    rescue StandardError => e
      batch.update!(status: :erro)
      Rails.logger.error "Erro ao processar o arquivo CSV: #{e.message}"
    end
  end

  private

  def delete_file(file_path)
    if File.exist?(file_path)
      File.delete(file_path)
      Rails.logger.info "Arquivo deletado: #{file_path}"
    else
      Rails.logger.error "Arquivo não encontrado para deletar: #{file_path}"
    end
  end
end
