require "application_system_test_case"

class MobileReleasesTest < ApplicationSystemTestCase
  setup do
    @mobile_release = mobile_releases(:one)
  end

  test "visiting the index" do
    visit mobile_releases_url
    assert_selector "h1", text: "Mobile Releases"
  end

  test "creating a Mobile release" do
    visit mobile_releases_url
    click_on "New Mobile Release"

    fill_in "Android number of installs", with: @mobile_release.android_number_of_installs
    fill_in "Android update type", with: @mobile_release.android_update_type
    fill_in "Build code", with: @mobile_release.build_code
    fill_in "Ios number of installs", with: @mobile_release.ios_number_of_installs
    fill_in "Ios update type", with: @mobile_release.ios_update_type
    check "Maintenance mode" if @mobile_release.maintenance_mode
    click_on "Create Mobile release"

    assert_text "Mobile release was successfully created"
    click_on "Back"
  end

  test "updating a Mobile release" do
    visit mobile_releases_url
    click_on "Edit", match: :first

    fill_in "Android number of installs", with: @mobile_release.android_number_of_installs
    fill_in "Android update type", with: @mobile_release.android_update_type
    fill_in "Build code", with: @mobile_release.build_code
    fill_in "Ios number of installs", with: @mobile_release.ios_number_of_installs
    fill_in "Ios update type", with: @mobile_release.ios_update_type
    check "Maintenance mode" if @mobile_release.maintenance_mode
    click_on "Update Mobile release"

    assert_text "Mobile release was successfully updated"
    click_on "Back"
  end

  test "destroying a Mobile release" do
    visit mobile_releases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mobile release was successfully destroyed"
  end
end
