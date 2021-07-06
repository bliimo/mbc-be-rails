class Api::V1::DocumentsController < Api::V1::ApiController
  
  def terms_and_conditions
    render json: TermsAndCondition.last
  end

  def privacy_policy
    render json: PrivacyPolicy.last
  end
end
