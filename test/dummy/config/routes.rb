Rails.application.routes.draw do
  mount Kadmin::Engine => Kadmin.config.mount_path, as: :kadmin

  get '/', to: -> (_env) do
    [200, { 'Content-Type' => 'text/plain' }, ['Sup my guy']]
  end

  get '/admin', controller: :admin, action: :index
  get '/authorized', controller: :authorized, action: :index
end
