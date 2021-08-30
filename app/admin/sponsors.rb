ActiveAdmin.register Sponsor do
  permit_params :name, :description, :status


  filter :name
  filter :status

  index do 
    selectable_column
    id_column
    column :name
    column :status do |sponsor| 
      status_tag sponsor.status
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.input :name
    f.input :description, input_html: { rows: "2" }
    f.input :status, include_blank: false
    f.actions
  end

  show do
    panel sponsor.name do
      attributes_table_for sponsor do
        row :name
        row :description
        row :status do 
          status_tag sponsor.status
        end
      end
    end
  end
end
