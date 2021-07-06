class TermsAndCondition < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "terms_and_conditions"
end
