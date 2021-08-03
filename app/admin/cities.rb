ActiveAdmin.register City do
  menu parent: 'Addresses'
  permit_params :code, :name, :province_id
end
