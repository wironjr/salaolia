class CreateCaixas < ActiveRecord::Migration[6.1]
  def change
    create_table :caixas do |t|
      t.date :data
      t.string :nome_cliente
      t.string :servico
      t.string :valor

      t.timestamps
    end
  end
end
