RailsAdmin::Engine.routes.draw do
  get '/', controller: :dash, action: :index

  scope '/auth', controller: :auth, as: 'auth', defaults: { format: 'html' } do
    get '/login', action: :login
    get '/logout', action: :logout
    get '/:provider/callback', action: :save
    post '/:provider/callback', action: :save
    get '/failure', action: :failure
  end
end
