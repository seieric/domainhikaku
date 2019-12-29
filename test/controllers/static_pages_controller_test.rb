require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "最安ドメイン検索"
  end
  test "should get help" do
    get static_pages_help_path
    assert_response :success
    assert_select "title", "ヘルプ | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_path
    assert_response :success
    assert_select "title", "このサイトについて | #{@base_title}"
  end

  test "should get terms" do
    get static_pages_terms_path
    assert_response :success
    assert_select "title", "利用規約 | #{@base_title}"
  end

  test "should get policy" do
    get static_pages_policy_path
    assert_response :success
    assert_select "title", "プライバシーポリシー | #{@base_title}"
  end

  test "should get contact" do
    get static_pages_contact_path
    assert_response :success
    assert_select "title", "お問い合わせ | #{@base_title}"
  end
end
