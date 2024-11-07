# app/models/boleto.rb
class Boleto < ApplicationRecord
  belongs_to :batch

  validates :barcode, :valor, presence: true
  validates :valor, numericality: { greater_than: 0 }

  def pago?
    status == 'pago'
  end

  def invalido?
    status == 'invalido'
  end
end
