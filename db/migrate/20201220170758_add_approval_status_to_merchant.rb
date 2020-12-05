class AddApprovalStatusToMerchant < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :approval_status, :integer
  end
end
