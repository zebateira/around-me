require 'test_helper'

class LandmarksControllerTest < ActionController::TestCase
  setup do
    @landmark = landmarks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:landmarks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create landmark" do
    assert_difference('Landmark.count') do
      post :create, landmark: { about: @landmark.about, category: @landmark.category, checkins: @landmark.checkins, description: @landmark.description, general_info: @landmark.general_info, id: @landmark.id, is_published: @landmark.is_published, likes: @landmark.likes, link: @landmark.link, location_city: @landmark.location_city, location_country: @landmark.location_country, location_latitude: @landmark.location_latitude, location_longitude: @landmark.location_longitude, location_street: @landmark.location_street, location_zip: @landmark.location_zip, name: @landmark.name, phone: @landmark.phone, public_transit: @landmark.public_transit, talking_about_count: @landmark.talking_about_count, username: @landmark.username, website: @landmark.website, were_here_count: @landmark.were_here_count }
    end

    assert_redirected_to landmark_path(assigns(:landmark))
  end

  test "should show landmark" do
    get :show, id: @landmark
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @landmark
    assert_response :success
  end

  test "should update landmark" do
    put :update, id: @landmark, landmark: { about: @landmark.about, category: @landmark.category, checkins: @landmark.checkins, description: @landmark.description, general_info: @landmark.general_info, id: @landmark.id, is_published: @landmark.is_published, likes: @landmark.likes, link: @landmark.link, location_city: @landmark.location_city, location_country: @landmark.location_country, location_latitude: @landmark.location_latitude, location_longitude: @landmark.location_longitude, location_street: @landmark.location_street, location_zip: @landmark.location_zip, name: @landmark.name, phone: @landmark.phone, public_transit: @landmark.public_transit, talking_about_count: @landmark.talking_about_count, username: @landmark.username, website: @landmark.website, were_here_count: @landmark.were_here_count }
    assert_redirected_to landmark_path(assigns(:landmark))
  end

  test "should destroy landmark" do
    assert_difference('Landmark.count', -1) do
      delete :destroy, id: @landmark
    end

    assert_redirected_to landmarks_path
  end
end
