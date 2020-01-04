require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  def setup
    @contact = Contact.new(email: "example@example.com", name: "Seiya", message: "hello")
  end
  test "contact_mail" do
    mail = ContactMailer.contact_mail(@contact)
    assert_equal "新規問い合わせ", mail.subject
    assert_equal [ENV["ADMIN_EMAIL_ADDR"]], mail.to
    #assert_equal ["from@example.com"], mail.from
  end

end
