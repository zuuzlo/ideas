Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  
  devise_for :users, :path => "accounts"
  #root to: 'devise/sessions#new'

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :ideas do
    resources :notes do
      :notes
    end

    resources :idea_links do
      :idea_links
    end

    member do
      get :move_up
      get :move_down
    end

    resources :tasks do
      :tasks
=begin
      collection do
        get 'tab_active'
        get 'tab_hold'
        get 'tab_complete'
        get 'tab_all'
      end

      member do
        post :update_task
        get :more_less
      end
=end
    end

    member do
      post :update_status
      post :remove_category
    end
  end

  resources :tasks do
    
    collection do
      get 'tab_active'
      get 'tab_hold'
      get 'tab_complete'
      get 'tab_all'
    end

    member do
      post :update_task
      get :more_less
      get :show_children
      get :move_up
      get :move_down
    end

    resources :tasks do
      :tasks
    end

    resources :notes do
      :notes
    end

    resources :idea_links do
      :idea_links
    end
  end

  resources :categories do
    resources :notes do
      :notes
    end
  end

  resources :notes do
    resources :notes do
      :notes
    end
  end

  resources :jots do
    member do
      get :move_up
      get :move_down
      get :to_new_idea
      post :to_new_task
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
