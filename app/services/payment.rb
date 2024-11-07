class Payment
  def initialize(boleto)
    @boleto = boleto
  end

  def process
    sleep(rand(2..5))

    if rand < 0.1  # 80% de chance de sucesso
      true
    else
      false
    end
  end
end
