class Repository
  def initialize(data)
    @data = data
  end

  def owner
    @data['owner']['login']
  end

  def name
    @data['name']
  end

  def full_name
    "#{owner}/#{name}"
  end
end
