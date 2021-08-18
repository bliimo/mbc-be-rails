ActiveAdmin.register_page "VersionManager" do
  menu parent: ["Settings"], priority: 1, label: "Version Manager"

  page_action :update, method: :post do
    mobile_release_params = params[:mobile_release]
    mobile_release = MobileRelease.first || MobileRelease.create(
      build_code: 1,
      update_type: 'No notice',
      maintenance_mode: false
    )
    mobile_release.build_code = mobile_release_params[:build_code]
    mobile_release.maintenance_mode = mobile_release_params[:maintenance_mode].present?

    if mobile_release_params[:notify_update].present?
      if mobile_release_params[:force_update].present?
        mobile_release.update_type = "Force update"
      else
        mobile_release.update_type = "Notify update"
      end
    else
      mobile_release.update_type = "No notice"
    end

    mobile_release.save
    redirect_to admin_versionmanager_path, notice: "Updated"
  end

  content title: "Version Manager" do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      render 'form', version: MobileRelease.first || MobileRelease.new
    end
  end
end
