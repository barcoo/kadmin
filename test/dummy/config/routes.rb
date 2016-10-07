Rails.application.routes.draw do
  mount Kadmin::Engine => Kadmin.config.mount_path, as: :kadmin

  get '/', to: -> (_env) do # rubocop: disable Style/Lambda
    [200, { 'Content-Type' => 'text/plain' }, ['Howdy']]
  end

  namespace :admin do
    resources :people
    resources :groups
  end

  get '/authorized', controller: :authorized, action: :index
end
