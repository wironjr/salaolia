class CreateAgendamentos < ActiveRecord::Migration[6.1]
  def change
    create_table :agendamentos do |t|
      t.date :data
      t.string :hora, null: false, default: ''
      t.string :nome
      t.string :servico
      t.string :telefone

      t.timestamps
    end
  end
end
