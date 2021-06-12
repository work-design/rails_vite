Rails.application.routes.draw do
  get '@fs/*path' => 'viter/common#index'
  get 'images/*path' => 'viter/common#image'
end
