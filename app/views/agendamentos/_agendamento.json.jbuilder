json.extract! agendamento, :id, :data, :hora, :nome, :servico, :created_at, :updated_at
json.url agendamento_url(agendamento, format: :json)
