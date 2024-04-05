require "test_helper"

class WaterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get water_index_url
    assert_response :success
  end

  test "should get show" do
    get water_show_url
    assert_response :success
  end
end
