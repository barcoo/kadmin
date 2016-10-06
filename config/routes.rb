Kadmin::Engine.routes.draw do
  get '/', controller: :dash, action: :index

  scope '/auth', controller: :auth, as: 'auth', defaults: { format: 'html' } do
    get '/login', action: :login, as: :login
    get '/logout', action: :logout, as: :logout
    get '/:provider/callback', action: :save
    post '/:provider/callback', action: :save
    get '/failure', action: :failure, as: :failure
    get '/unauthorized', action: :unauthorized, as: :unauthorized
  end
end
