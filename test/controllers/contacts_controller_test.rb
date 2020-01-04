require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "最安ドメイン検索"
  end
  test "should get contacts" do
    get contacts_path
    assert_response :success
    assert_select "title", "お問い合わせ | #{@base_title}"
  end
end
