Rails.application.routes.draw do
  get '/', to: -> (_env) do # rubocop: disable Style/Lambda
    [200, { 'Content-Type' => 'text/plain' }, ['Howdy']]
  end

  namespace :admin do
    resources :people
    resources :groups
  end
  mount Kadmin::Engine => Kadmin.config.mount_path, as: :kadmin

  get '/authorized', controller: :authorized, action: :index
end
