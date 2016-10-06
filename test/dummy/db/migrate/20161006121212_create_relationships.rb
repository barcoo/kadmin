class CreateJobs < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :name
      t.references :person_from
      t.references :person_to
      t.timestamps null: false

      t.index [:person_from, :person_to, :name], name: 'relationships_person_lookup'
    end
  end
end
