Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  # get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  resources :users
  resources :private_messages
  resources :chat_rooms
  # get 'users' => 'users#index'
  # get 'users/:userId' => 'users#show'
  get 'users/:userId/friends/:friendId/messages' => 'private_messages#conversation'
  post 'users/:userId/friends/:friendId/messages' => 'private_messages#create'

  get 'users/:userId/chat_rooms' => 'chat_rooms#index'
  post 'users/:userId/chat_rooms' => 'chat_rooms#create'

  get 'users/:userId/chat_rooms/:chatRoomId/messages' => 'chat_room_messages#conversation'
  post 'users/:userId/chat_rooms/:chatRoomId/messages' => 'chat_room_messages#create'

  # Example resource route (maps HTTP verbs to controller actions automatically):

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
