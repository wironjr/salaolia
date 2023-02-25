class AddValorRealToDespesas < ActiveRecord::Migration[6.1]
  def change
    add_column :despesas, :valor_real, :decimal
  end
end
