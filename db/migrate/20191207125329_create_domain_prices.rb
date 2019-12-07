class CreateDomainPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_prices do |t|
      t.string :domain, null: false, index: true
      t.integer :price, null: false
      t.string :registrar, null: false

      t.timestamps
    end
  end
end
