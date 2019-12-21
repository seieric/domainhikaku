class CreateDomainPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :domain_prices do |t|
      t.string :domain, index: true
      t.integer :register_price
      t.integer :update_price
      t.string :registrar, index: true

      t.timestamps
    end
  end
end
