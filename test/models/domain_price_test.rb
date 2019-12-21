require 'test_helper'

class DomainPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @domain = DomainPrice.new(domain: ".org", price: 1300, registrar: "x_domain")
  end

  test "should be valid" do
    assert @domain.valid?
  end

  test "domain should be valid" do
    @domain.domain = ""
    assert_not @domain.valid?
  end

  test "price shoud be valid" do
    @domain.price = ""
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

  test "price should be integer" do
    @domain.price = "hhkdhjfnci"
    assert_not @domain.valid?
  end

  test "price should be not be negative" do
    @domain.price = -10
    assert_not @domain.valid?
  end

  #registrarは設定値で不変なため検証しない
end
