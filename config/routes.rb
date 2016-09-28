RailsAdmin::Engine.routes.draw do
  get '/', to: -> (_env) do
    [200, { 'Content-Type' => 'text/plain' }, ['Test']]
  end

  scope '/auth', controller: :auth, as: 'auth', defaults: { format: 'html' } do
    get '/login', action: :login
    get '/logout', action: :logout
    get '/:provider/callback', action: :save
    post '/:provider/callback', action: :save
    get '/failure', action: :failure
  end
end
