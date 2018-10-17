require 'test_helper'

class RerunFavoritesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rerun_favorites_index_url
    assert_response :success
  end

end
