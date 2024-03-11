class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :door_no
      t.string :street_name
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.timestamps
    end
  end
end
