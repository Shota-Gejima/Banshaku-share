require "test_helper"

class Public::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_relationships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get public_relationships_destroy_url
    assert_response :success
  end
end
