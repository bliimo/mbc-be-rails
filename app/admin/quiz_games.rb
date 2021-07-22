ActiveAdmin.register QuizGame do
  menu parent: ["Games"]

  permit_params :title, :description, :sponsor_id, :city_id, :radio_station_id, :price, :number_of_winner, :schedule, :status, :image
  
  index do
    selectable_column
    id_column
    column :title
    column :sponsor
    column :network do |quiz_game| 
      quiz_game.radio_station.name
    end
    column :price
    column :number_of_winner
    column :schedule
    column :status do |quiz_game|
      status_tag quiz_game.status
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.input :image, as: :file
    f.input :title
    f.input :description
    f.input :sponsor
    f.input :city
    f.input :radio_station
    f.input :price
    f.input :number_of_winner
    f.input :schedule
    f.input :status
    f.actions
  end
  
  show do |quiz|

    panel quiz.title do
      tabs do
        
        tab 'General' do
          columns do
            column span: 3 do
              attributes_table_for quiz do
                row :id
                row :title
                row :description
                row :sponsor
                row :city
                row :radio_station
                row :price
                row :number_of_winner
                row :schedule
    
                row :status do
                  status_tag quiz.status.present? ? quiz.status : 'Inactive'
                end
              end
            end
  
            column do
              if quiz.image.attached?
                image_tag quiz.image, class: 'width-100'
              end
            end
          end
          
        end
        tab 'Questions' do

        end
        tab 'Participants' do

        end
      end
    end
  end


end
