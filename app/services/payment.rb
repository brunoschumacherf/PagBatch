class Payment
  def initialize(boleto)
    @boleto = boleto
  end

  def process
    sleep(rand(2..5))

    if rand < 0.8  # 80% de chance de sucesso
      OpenStruct.new(success?: true)
    else
      OpenStruct.new(success?: false, error_message: "Falha na comunicação com o banco")
    end
  end
end
