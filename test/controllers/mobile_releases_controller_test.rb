require 'test_helper'

class MobileReleasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mobile_release = mobile_releases(:one)
  end

  test "should get index" do
    get mobile_releases_url
    assert_response :success
  end

  test "should get new" do
    get new_mobile_release_url
    assert_response :success
  end

  test "should create mobile_release" do
    assert_difference('MobileRelease.count') do
      post mobile_releases_url, params: { mobile_release: { android_number_of_installs: @mobile_release.android_number_of_installs, android_update_type: @mobile_release.android_update_type, build_code: @mobile_release.build_code, ios_number_of_installs: @mobile_release.ios_number_of_installs, ios_update_type: @mobile_release.ios_update_type, maintenance_mode: @mobile_release.maintenance_mode } }
    end

    assert_redirected_to mobile_release_url(MobileRelease.last)
  end

  test "should show mobile_release" do
    get mobile_release_url(@mobile_release)
    assert_response :success
  end

  test "should get edit" do
    get edit_mobile_release_url(@mobile_release)
    assert_response :success
  end

  test "should update mobile_release" do
    patch mobile_release_url(@mobile_release), params: { mobile_release: { android_number_of_installs: @mobile_release.android_number_of_installs, android_update_type: @mobile_release.android_update_type, build_code: @mobile_release.build_code, ios_number_of_installs: @mobile_release.ios_number_of_installs, ios_update_type: @mobile_release.ios_update_type, maintenance_mode: @mobile_release.maintenance_mode } }
    assert_redirected_to mobile_release_url(@mobile_release)
  end

  test "should destroy mobile_release" do
    assert_difference('MobileRelease.count', -1) do
      delete mobile_release_url(@mobile_release)
    end

    assert_redirected_to mobile_releases_url
  end
end
