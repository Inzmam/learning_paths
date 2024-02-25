Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :learning_paths
      resources :talents

      resources :learning_paths, only: [] do
        member do
          post 'add_course'
          delete 'remove_course'
        end
      end

      resources :authors do
        resources :courses do
          member do
            post 'reassign_course'
            post 'add_talent'
            post 'remove_talent'
            post 'mark_complete'
          end
        end
      end

    end
  end

end
