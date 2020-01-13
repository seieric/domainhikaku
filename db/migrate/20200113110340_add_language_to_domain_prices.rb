class AddLanguageToDomainPrices < ActiveRecord::Migration[6.0]
  def change
    add_column :domain_prices, :language, :string, after: :domain
  end
end
