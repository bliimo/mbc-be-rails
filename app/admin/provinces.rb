ActiveAdmin.register Province do
  menu parent: 'Addresses'
  permit_params :region_id, :name, :code
end
