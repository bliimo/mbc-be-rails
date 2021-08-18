class Api::V2::VersionCheckerController < Api::V2::ApiController
  def latest_version
    render json: MobileRelease.first || MobileRelease.create(
      build_code: 1,
      update_type: 'No notice',
      maintenance_mode: false
    )
  end
end
