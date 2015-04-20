Sequel.migration do
  up do
    create_table(:temas_seleccionados) do
      primary_key :id
      String :login, :null=>false
      String :tema, :null=>false
      Integer :orden, :null=>false
    end
  end

  down do
    drop_table(:temas_seleccionados)
  end
end
