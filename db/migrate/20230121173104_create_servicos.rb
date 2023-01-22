class CreateServicos < ActiveRecord::Migration[6.1]
  def change
    create_table :servicos do |t|
      t.date :data
      t.string :nome_cliente
      t.string :servico
      t.string :valor

      t.timestamps
    end
  end
end
