class RenameColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :domain_prices, :register_price, :registration_price
    rename_column :domain_prices, :update_price,   :renewal_price
  end
end
