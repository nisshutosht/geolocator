class CreateApiV1Geolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :api_v1_geolocations do |t|
      t.string :city
      t.string :country
      t.string :country_code
      t.string :ip_address, index: { unique: true }
      t.string :latitude
      t.string :longitude
      t.string :postal_code
      t.string :province
      t.string :url
      t.jsonb :service_response

      t.timestamps
    end
  end
end
