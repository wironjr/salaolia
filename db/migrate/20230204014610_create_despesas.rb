class CreateDespesas < ActiveRecord::Migration[6.1]
  def change
    create_table :despesas do |t|
      t.date :data
      t.string :descricao
      t.string :valor

      t.timestamps
    end
  end
end
