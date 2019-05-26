class PolicyExerciser
  def initialize(policy, action)
    @policy = policy
    @action = action
  end

  def allowed?(person:, record:)
    @policy.new(person, record).send(@action)
  end
end