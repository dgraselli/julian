Sequel.migration do
  up do
    create_table(:persons) do
      primary_key :id
      String :name, :null=>false
    end
  end

  down do
    drop_table(:persons)
  end
end
