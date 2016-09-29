Rails.application.routes.draw do
  mount RailsAdmin::Engine => RailsAdmin.config.mount_path, as: :rails_admin

  get '/', to: -> (_env) do
    [200, { 'Content-Type' => 'text/plain' }, ['Sup my guy']]
  end

  get '/admin', controller: :admin, action: :index
  get '/authorized', controller: :authorized, action: :index
end
