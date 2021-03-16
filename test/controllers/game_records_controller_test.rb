require 'test_helper'

class GameRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_record = game_records(:one)
  end

  test "should get index" do
    get game_records_url
    assert_response :success
  end

  test "should get new" do
    get new_game_record_url
    assert_response :success
  end

  test "should create game_record" do
    assert_difference('GameRecord.count') do
      post game_records_url, params: { game_record: { game_id: @game_record.game_id, start_time: @game_record.start_time, winners: @game_record.winners } }
    end

    assert_redirected_to game_record_url(GameRecord.last)
  end

  test "should show game_record" do
    get game_record_url(@game_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_record_url(@game_record)
    assert_response :success
  end

  test "should update game_record" do
    patch game_record_url(@game_record), params: { game_record: { game_id: @game_record.game_id, start_time: @game_record.start_time, winners: @game_record.winners } }
    assert_redirected_to game_record_url(@game_record)
  end

  test "should destroy game_record" do
    assert_difference('GameRecord.count', -1) do
      delete game_record_url(@game_record)
    end

    assert_redirected_to game_records_url
  end
end
