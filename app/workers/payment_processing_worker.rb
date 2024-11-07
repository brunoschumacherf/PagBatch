require 'byebug'
class PaymentProcessingWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5

  def perform(boleto_id)
    boleto = Boleto.find(boleto_id)

    begin
      # Chamando o serviço de pagamento
      payment = Payment.new(boleto)
      result = payment.process

      if result
        boleto.update!(status: 'pago')
      else
        boleto.update!(status: 'Tentando novamente')
        raise "Pagamento falhou para o boleto #{boleto.id}"  # Lançando uma exceção para acionar o retry
      end
    rescue StandardError => e
      # Atualiza o status para 'erro' apenas na última tentativa
      if sidekiq_retries_exhausted_block
        boleto.update!(status: 'erro')
      end

      Rails.logger.error "Erro ao processar o pagamento do boleto #{boleto.id}: #{e.message}"
      raise e  # Re-levanta a exceção para que o Sidekiq tente novamente
    end
  end
end
