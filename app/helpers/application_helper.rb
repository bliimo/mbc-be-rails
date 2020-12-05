module ApplicationHelper
  def format_time(date)
    return date if date.nil?

    begin
      date.strftime('%I:%M %p')
    rescue ArgumentError
      'Not available'
    end
  end

  def format_date(date)
    return date if date.nil?

    begin
      date.to_date.strftime('%B %e, %Y')
    rescue ArgumentError
      'Not available'
    end
  end

  def render_status(status)
    style = case status
            when 'Active', 'Finished'
              'bg-success'
            when 'Verified'
              'bg-success'
            when 'Unverified'
              'bg-danger'
            when 'Public'
              'bg-success'
            when 'Inactive'
              'bg-danger'
            when 'Pending'
              'bg-primary'
            when 'Processing'
              'bg-info'
            when 'Shipping', 'Ongoing'
              'bg-warning'
            when 'Delivered'
              'bg-success'
            when 'Failed'
              'bg-danger'
            when 'Declined'
              'bg-danger'
            when 'Cancelled'
              'bg-danger'
            when 'Approved'
              'bg-success'
            else
              'bg-primary'
            end
    data = "<span class='status-text #{style}'>#{status}</span>"
    data.html_safe
  end

  def render_required
    "<span class='text-danger'>*required</span>".html_safe
  end

  def format_currency(currency)
    if currency.present?
      number_to_currency(currency, unit: '₱', separator: '.', delimiter: ',')
    else
      currency
    end
  end
end
