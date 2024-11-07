# app/models/batch.rb
class Batch < ApplicationRecord
  has_many :boletos, dependent: :destroy

  # Statuses possíveis para o batch
  enum status: { pendente: 'pendente', processado: 'processado', erro: 'erro' }
end
