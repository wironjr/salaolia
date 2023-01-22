json.extract! servico, :id, :data, :nome_cliente, :servico, :valor, :created_at, :updated_at
json.url servico_url(servico, format: :json)
