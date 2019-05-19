class AddOnboardingQuestionToCommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :onboarding_question, :string
  end
end
