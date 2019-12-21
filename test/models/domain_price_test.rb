require 'test_helper'

class DomainPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @domain = DomainPrice.new(domain: ".org", register_price: 1300, update_price: 1300, registrar: "x_domain")
  end

  test "should be valid" do
    assert @domain.valid?
  end

  test "domain should be valid" do
    @domain.domain = ""
    assert_not @domain.valid?
  end

  test "register_price should be valid" do
    @domain.register_price = ""
    assert_not @domain.valid?
  end

  test "update_price should be valid" do
    @domain.update_price = ""
    assert_not @domain.valid?
  end

  test "registrar should be valid" do
    @domain.registrar = ""
    assert_not @domain.valid?
  end

  test "domain should not be too long" do
    @domain.domain = "a"*31
    assert_not @domain.valid?
  end

  test "*_price should be integer" do
    @domain.register_price = "hhkdhjfnci"
    @domain.update_price =
    assert_not @domain.valid?
  end

  test "*_price should be not be negative" do
    @domain.register_price = -10
    @domain.update_price = -10
    assert_not @domain.valid?
  end

  #registrarは設定値で不変なため検証しない
end
