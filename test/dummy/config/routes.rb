Rails.application.routes.draw do
  scope '/admin', controller: :admin do
    get '/', action: :index
  end

  scope '/auth', controller: :auth, as: 'auth', defaults: { format: 'html' } do
    get '/login', action: :login
    get '/logout', action: :logout
    post '/:provider/callback', action: :save
  end
  get '/auth/failure' do
    flash.alert = params[:message]
    redirect_to '/auth/login'
  end
end
