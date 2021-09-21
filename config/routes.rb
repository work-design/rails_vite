Rails.application.routes.draw do
  get '@fs/*path' => 'vite/common#index'
  get 'images/*path' => 'vite/common#image'
end
