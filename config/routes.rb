require 'sidekiq/web'


Rails.application.routes.draw do
  # Definindo a rota raiz (página inicial)
  root 'batches#index'

  # Rota para exibir todos os lotes de pagamento
  resources :batches, only: [:index, :show, :new, :create]

  mount Sidekiq::Web => '/sidekiq'


  # Rota para exibir os boletos de um lote específico
  # Ex: /batches/:id para visualizar os boletos do lote
  resources :boletos, only: [:show]
end
