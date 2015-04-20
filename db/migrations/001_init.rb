Sequel.migration do
  up do
    create_table(:personas) do
      primary_key :id
      String :login, :null=>false
      String :name, :null=>false
    end
  end

  down do
    drop_table(:personas)
  end
end
