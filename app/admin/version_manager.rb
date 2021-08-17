ActiveAdmin.register_page "VersionManager" do
  menu parent: ["Settings"], priority: 1, label: "Version Manager"


  content title: "Version Manager" do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        p "Welcome to MBC Dashboard"
      end



    end


  end
end
