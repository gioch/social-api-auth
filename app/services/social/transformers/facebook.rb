class Social::Transformers::Facebook
  def initialize(data)
    @data = data
    @provider = 'facebook'
  end

  def data
    {
      uid: @data['id'],
      name: @data['name'],
      email: @data['email'],
      provider: @provider
    }
  end
end
