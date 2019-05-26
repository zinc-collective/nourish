class AddOnboardingQuestionResponseToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :onboarding_question_response, :string
  end
end
