class Init < ActiveRecord::Migration
  def change
      create_table :personas do |t|
        t.string  :login
        t.string  :name
      end

      create_table(:temas_seleccionados) do |t|
        t.string :login
        t.string :tema
        t.integer :orden
      end

  end
end
