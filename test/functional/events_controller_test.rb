require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { description: @event.description, end_time: @event.end_time, id: @event.id, is_date_only: @event.is_date_only, location: @event.location, name: @event.name, owner_category: @event.owner_category, owner_id: @event.owner_id, owner_name: @event.owner_name, privacy: @event.privacy, start_time: @event.start_time, timezone: @event.timezone, updated_time: @event.updated_time, venue_id: @event.venue_id, venue_latitude: @event.venue_latitude, venue_longitude: @event.venue_longitude }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    put :update, id: @event, event: { description: @event.description, end_time: @event.end_time, id: @event.id, is_date_only: @event.is_date_only, location: @event.location, name: @event.name, owner_category: @event.owner_category, owner_id: @event.owner_id, owner_name: @event.owner_name, privacy: @event.privacy, start_time: @event.start_time, timezone: @event.timezone, updated_time: @event.updated_time, venue_id: @event.venue_id, venue_latitude: @event.venue_latitude, venue_longitude: @event.venue_longitude }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
end
