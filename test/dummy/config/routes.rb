Rails.application.routes.draw do
  mount Postman::Web::Engine => '/postman', as: 'postman/web'
end
