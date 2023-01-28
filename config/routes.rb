Rails.application.routes.draw do
  
  root to: "static_pages#index" #para pagina inicial

  resources :servicos do
    get :caixa_total, on: :collection #usar collection pra trazer lista de dados
    get :servicos_do_dia, on: :collection
  end

  get 'entrar', to: 'sessions#new'
  post 'entrar', to: 'sessions#create'
  delete 'sair', to: 'sessions#destroy'

  resources :users, only: [:new, :create]
  
  resources :caixas
  
  
end
