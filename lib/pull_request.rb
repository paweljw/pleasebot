class PullRequest
  def initialize(repo, data, redis, octokit)
    @data = data
    @repo = repo
    @redis = redis
    @octokit = octokit
  end

  def assignees
    @data['assignees']
  end

  def id
    @data['id']
  end

  def number
    @data['number']
  end

  def author
    @data['user']['login']
  end

  def assigned?
    assignees.count >= ASSIGNEES_ENOUGH
  end

  def assignable?
    assigned? && @redis.get(id).nil?
  end

  def random_assignees
    (assignees.map { |assignee| assignee['login'] } - [author]).sample(2)
  end

  def assign!
    puts "Rolling the dice... *drum roll*..."
    assignees = random_assignees
    @octokit.request_pull_request_review(@repo.full_name, number.to_i, assignees,
                                       accept: 'application/vnd.github.black-cat-preview')
    people = assignees.map { |assignee| "@#{assignee}" }.join(' ')
    @octokit.add_comment(@repo.full_name, number.to_i,
                          "Hey @#{author}, thanks for assigning people to this pull request!" \
                          " #{people} were requested to review this on your behalf.")
    @redis.set(id, true)
  end
end
