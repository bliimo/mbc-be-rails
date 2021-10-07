class AdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)

    if user.super_admin?
      return true
    end
    
    if user.admin?
      case subject
      when ActiveAdmin::Page
        case subject.name
        when "Dashboard"
          return true          
        else
          return false
        end
      when normalized(AdminUser)
        return true if action == :read || action == :create
        return false if action == :destroy
        return true if action == :update && subject.dj?
      when normalized(Roulette)
        return true if action == :read || action == :create
        return true if action == :update && subject.pending?
      when normalized(User)
        return true if action == :read
      when normalized(Sponsor)
        return true if action == :read
        return true if action == :create
      when normalized(Network)
        return true if action == :read
      when normalized(RadioStation)
        return true if action == :read
        return true if action == :create
        return true if action == :update && user.network_ids.include?(subject.network_id)
      else
        false
      end

    end

    if user.dj?
      case subject
      when ActiveAdmin::Page
        case subject.name
        when "Dashboard"
          return true          
        else
          return false
        end
      when normalized(AdminUser)
        return true if action == :read 
        return true if action == :update && subject.id == user.id
      when normalized(Roulette)
        return true if action == :read || action == :create
      when normalized(User)
        return true if action == :read
      when normalized(Sponsor)
        return true if action == :read
      else
        false
      end
    end
  end

  def scope_collection(collection, action = Auth::READ)
    if user.admin?
      if collection == AdminUser
        return collection.joins(:networks).where(networks: {id: user.network_ids})
      end
      if collection == Roulette
        return collection.joins(:radio_station).where(radio_stations: {network_id: user.network_ids})
      end
      if collection == RadioStation
        return collection.joins(:network).where(networks: {id: user.network_ids})
      end
    end
    if user.dj?
      if collection == AdminUser
        return collection.where(id: user.id)
      end
      if collection == Roulette
        return collection.joins(:radio_station).where(radio_stations: {network_id: user.network_ids})
      end
    end
    return collection
  end

end