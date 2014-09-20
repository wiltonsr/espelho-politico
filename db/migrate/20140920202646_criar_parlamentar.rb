class CriarParlamentar < ActiveRecord::Migration
  def change
    create_table :parlamentar do |t|
      t.string  :matricula
      t.string  :condicao
      t.string  :nome
      t.string  :url_foto
      t.string  :uf
      t.string  :partido
      t.string  :telefone
      t.string  :email
      t.integer :gabinete
    end
  end
end
