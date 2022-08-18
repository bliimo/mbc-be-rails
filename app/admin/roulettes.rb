ActiveAdmin.register Roulette do
  menu parent: ['Games'], priority: 1

  permit_params :radio_station_id, :location_restriction, :location_restriction_type, :text_description, :dj_id,
                :sponsor_id, :name, :number_of_winner, :price, :schedule, :redemption_details, :dti_permit, :winner_prompt,
                :popper_visible, :banderitas_visible, :background, :banner, :top_banner, :winner_background, :status, city_ids: [],
                                                                                                                      pies_attributes: %i[
                                                                                                                        id
                                                                                                                        icon
                                                                                                                        name
                                                                                                                        color
                                                                                                                      ]

  after_save do |_roulette|
    GameChannel.broadcast_to(
      'ROULETTE',
      { type: 'GAMES_UPDATED' }
    )
  end

  member_action :allow_player_to_join, method: [:post] do
    resource.start_time = DateTime.now + params[:seconds].to_i.seconds
    resource.status = 'ready'
    resource.save
    redirect_to admin_roulette_path(resource), notice: 'Game is ready'
    GameChannel.broadcast_to(
      'ROULETTE',
      { type: 'GAMES_UPDATED' }
    )

    GameChannel.broadcast_to(
      resource,
      { type: 'GAME_UPDATED' }
    )
  end

  member_action :start_spin, method: [:post] do
    resource.status = 'in_progress'
    resource.start_time = DateTime.now
    resource.end_time = DateTime.now + Roulette.lobby_time.seconds
    resource.save
    GameChannel.broadcast_to(
      'ROULETTE',
      { type: 'GAMES_UPDATED' }
    )
    GameChannel.broadcast_to(
      resource,
      { type: 'START_SPIN' }
    )

    GameChannel.broadcast_to(
      resource,
      { type: 'GAME_UPDATED' }
    )

    Rails.logger.debug 'Setting countdown'
    time = Roulette.lobby_time - 5 + rand(0.0..5.0)
    Rails.logger.debug time.to_s
    redirect_to admin_roulette_path(resource), notice: 'Game is in progress'

    Thread.new do
      sleep time
      Rails.logger.debug 'Countdown finished'

      # check all joined users
      Rails.logger.debug 'Getting all users'
      players = resource.roulette_participants.spinner

      # Check if there are winners already
      if resource.roulette_participants.wins.count.positive?
        Rails.logger.debug 'WINNER GENERATION REJECTED'
        GameChannel.broadcast_to(
          'ROULETTE',
          { type: 'GAMES_UPDATED' }
        )
      else
        # generate winner
        # get number of players
        player_count = players.count
        number_of_winners = resource.number_of_winner
        number_of_winners = player_count if player_count < resource.number_of_winner

        Rails.logger.debug 'Player count: ' + player_count.to_s
        Rails.logger.debug 'Number of winners: ' + number_of_winners.to_s
        Rails.logger.debug 'Generating random indexes'

        indexes = []

        while indexes.count < number_of_winners
          random_index = Faker::Number.between(from: 0, to: player_count - 1)
          indexes.push(random_index) unless indexes.include? random_index
          Rails.logger.debug 'generated index: ' + random_index.to_s
        end

        Rails.logger.debug 'Generating Winners'

        winners = indexes.map do |item|
          players[item].winner = true
          players[item].save
          players[item]
        end

        Rails.logger.debug 'Generating Winners'
        # broadcast winner
        # Rails.logger.debug "broadcasting"
        GameChannel.broadcast_to(
          resource,
          { winners: winners, player_count: player_count, players: players, type: 'FINISHED' }
        )
        resource.end_time = DateTime.now
        resource.status = 'done'
        resource.save
        GameChannel.broadcast_to(
          'ROULETTE',
          { type: 'GAMES_UPDATED' }
        )
      end
      resource.status = 'done'
      resource.save
      GameChannel.broadcast_to(
        resource,
        { type: 'GAME_UPDATED' }
      )
    end
  end

  controller do
    def new
      super do
        resource.pies << Pie.new(name: 'Winner', color: format('#%06x', (rand * 0xffffff)))
        11.times do
          resource.pies << Pie.new(name: 'Bokya', color: format('#%06x', (rand * 0xffffff)))
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :radio_station
    column :location_restriction
    column :dj
    column :schedule
    column :number_of_players do |roulette|
      roulette.roulette_participants.count
    end
    column :status do |roulette|
      status_tag roulette.status
    end
    actions
  end

  form do |f|
    if current_admin_user.super_admin?
      djs = AdminUser.djs
      radio_stations = RadioStation.all
    else
      radio_stations = RadioStation.all.where(network_id: current_admin_user.network_ids)
      djs = AdminUser.djs.joins(:networks).where(networks: { id: current_admin_user.network_ids })
    end

    tabs do
      tab 'Game Info' do
        f.input :radio_station, collection: radio_stations
        f.input :location_restriction
        div class: f.object.location_restriction ? '' : 'hide', id: 'roullete_location_restriction' do
          h4 'Location Restrictions'
          f.input :cities, as: :select, input_html: { multiple: true }, member_label: :label_name
          f.input :location_restriction_type
          f.input :text_description, input_html: { rows: 2 }
        end
        f.input :dj, collection: djs
        f.input :sponsor
        f.input :name, label: 'Title'
        f.input :number_of_winner
        f.input :price, label: 'Prize'
        f.input :background, as: :file
        f.input :winner_background, as: :file
        f.input :banner, as: :file
        f.input :top_banner, as: :file

        f.input :schedule, as: :datetime_picker
        f.input :redemption_details, input_html: { rows: 2 }
        f.input :dti_permit
        f.input :winner_prompt
        f.input :popper_visible, input_html: { checked: f.object.new_record? ? true : f.object.popper_visible }
        f.input :banderitas_visible, input_html: { checked: f.object.new_record? ? true : f.object.banderitas_visible }
        f.input :status
      end

      tab 'Pies' do
        f.has_many :pies,
                   new_record: 'Add Pie',
                   remove_record: 'Remove Pie',
                   allow_destroy: ->(_u) { current_admin_user.present? },
                   class: 'pie-input-container' do |b|
          b.input :icon, as: :file
          b.input :name
          b.input :color
        end
      end
    end
    f.actions
  end

  show do
    panel roulette.name do
      tabs do
        tab 'Lobby' do
          render 'lobby', roulette: roulette
        end
        tab 'Details' do
          columns do
            column span: 4 do
              attributes_table_for roulette do
                row :id

                row :radio_station
                row :location_restriction
                row :location_restriction_type
                row :text_description
                row :dj
                row :sponsor
                row :name
                row :number_of_winner
                row :prize do
                  roulette.price
                end
                row :schedule
                row :redemption_details
                row :dti_permit
                row :winner_prompt
                row :popper_visible
                row :banderitas_visible
                row :background
                row :winner_background
                row :cities
                row :start_time do
                  "#{roulette.start_time&.strftime('%r')}, #{roulette.start_time&.strftime('%D')}"
                end
                row :end_time do
                  "#{roulette.end_time&.strftime('%r')}, #{roulette.end_time&.strftime('%D')}"
                end

                row :status do
                  status_tag roulette.status.present? ? roulette.status : 'Inactive'
                end
              end
            end

            column do
              para 'Background'
              if roulette.background.attached?
                img src: url_for(roulette.background), style: 'width: 100%'
              else
                small 'No background image'
              end
              br

              para 'Winner Background'
              if roulette.winner_background.attached?
                img src: url_for(roulette.winner_background), style: 'width: 100%'
              else
                small 'No winner background image'
              end
              br
              para 'Top Banner'
              if roulette.top_banner.attached?
                img src: url_for(roulette.top_banner), style: 'width: 100%'
              else
                small 'No Top banner'
              end
              para 'Banner'
              if roulette.banner.attached?
                img src: url_for(roulette.banner), style: 'width: 100%'
              else
                small 'No banner'
              end
            end
          end
        end
        tab 'Pies' do
          div class: 'pie-container' do
            roulette.pies.each_with_index do |pie, _index|
              div class: 'pie', style: "background-color: #{pie.color || 'white'}" do
                if pie.icon.attached?
                  img src: url_for(pie.icon)
                else
                  img src: '/images/no-image.png'
                end
                para pie.name
              end
            end
          end
        end
      end
    end
  end
end
