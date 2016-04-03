Rails.application.routes.draw do
  # Authentication
  post 'auth', to: 'auth#create'
  delete 'auth', to: 'auth#destroy'
end
