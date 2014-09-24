class CriarProposicao < ActiveRecord::Migration
  def change
    create_table :proposicao do |t|
      t.integer      :ano
      t.integer      :numero
      t.text         :ementa
      t.text         :explicacao
      t.string       :tema
      t.references   :parlamentar
      t.date         :data_apresentacao
      t.string       :situacao
      t.string       :link_teor
    end
    add_index(
      :proposicao, 
      [:numero, :ano, :parlamentar_id],
      unique: true
    )
  end
end