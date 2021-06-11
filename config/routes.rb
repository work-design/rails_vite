Rails.application.routes.draw do
  get '@fs/*path' => 'ui/common#index'
  get 'images/*path' => 'ui/common#image'
end
