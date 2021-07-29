class AddDefaultBackgroundColor < ActiveRecord::Migration[6.0]
  def change
    change_column :question_choices, :background_color, :string, :default => "#ffffff"
  end
end
