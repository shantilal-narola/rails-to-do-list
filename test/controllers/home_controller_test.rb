require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get api_list" do
    get home_api_list_url
    assert_response :success
  end

end
