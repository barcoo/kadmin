Kadmin::Engine.routes.draw do
  get '/', controller: :dash, action: :index, as: :dash

  scope '/auth', controller: :auth, as: 'auth', defaults: { format: 'html' } do
    get '/login', action: :login, as: :login
    get '/logout', action: :logout, as: :logout
    match '/:provider/callback', action: :save, as: :callback, via: %i[get post]
    get '/failure', action: :failure, as: :failure
    get '/unauthorized', action: :unauthorized, as: :unauthorized
    get '/', action: :login
    post '/change_organization', action: :change_organization, as: :change_organization
  end
end
