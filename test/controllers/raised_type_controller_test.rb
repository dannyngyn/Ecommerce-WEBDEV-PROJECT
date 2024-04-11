require "test_helper"

class RaisedTypeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get raised_type_index_url
    assert_response :success
  end
end
