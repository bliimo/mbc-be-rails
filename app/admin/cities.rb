ActiveAdmin.register City do
  menu parent: 'Addresses'
  permit_params :code, :name, :province_id

  csv do
    column :id
    column :name
    column :province_id
    column :province do |city|
      city.province.name
    end
  end
end
