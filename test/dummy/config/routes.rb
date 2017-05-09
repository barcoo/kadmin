Rails.application.routes.draw do
  get '/', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['Howdy']] }

  get '/constrained', constraints: Kadmin::AuthConstraint.new,
                      to: proc { [200, { 'Content-Type' => 'text/plain' }, ['Howdyo']] }

  namespace :admin do
    resources :people
    resources :groups
  end
  mount Kadmin::Engine => Kadmin.config.mount_path, as: :kadmin

  get '/authorized', controller: :authorized, action: :index
end
