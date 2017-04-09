Rails.application.routes.draw do
  
  #devise_for :users
  devise_for :users, :skip => [:registrations]                                          
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
    put 'users' => 'devise/registrations#update', :as => 'user_registration'            
  end 
  
  get 'welcome', to: 'topics#welcome'
  post 'verify_account', to: 'topics#verify_account'
  
  get 'get_account', to: 'topics#get_account'
  post 'send_account', to: 'topics#send_account'
  
  get 'user_profile', to: 'topics#user_profile' 
  get 'user_management', to: redirect('user_management/2') 
  get 'user_management/new_users', to: 'topics#new_users', as: 'new_users'
  post 'user_management/destroy_user', to: 'topics#destroy_user', as: 'destroy_user'
  post 'user_management/create_users', to: 'topics#create_users', as: 'create_users'
  get 'user_management/edit_user/:id', to: 'topics#edit_user', as: 'edit_user'
  get 'user_management/update_user/:original_id', to: 'topics#update_user', as: 'update_user' 
  get 'user_management/:area', to: 'topics#user_management', as: 'show_users'

  get 'help', to: 'topics#help'
     
  root 'homeworks#index'
  
  resources :homeworks do
    resources :answers do
      resources :reviews
    end
  end
  
  get 'homeworks/:id/remind', to: 'homeworks#remind', as: 'remind_homework'
  
  resources :discussions do
    resources :messages
  end
  
  get 'grades/:district/upload_to_google', to: 'grades#upload_to_google', as: 'upload_grades'
  get 'grades/:district', to: 'grades#show_grades', as: 'show_grades'
  resources :grades

  get 'attendances/my_attendance/:student_id', to: 'attendances#my_attendance', as: 'my_attendance'
  get 'attendances/leave_request', to: 'attendances#leave_request', as: 'leave_request'
  get 'attendances/leave_request/send', to: 'attendances#send_leave_request', as: 'send_leave_request'
  get 'attendances/leave_request/list', to: 'attendances#list_requests', as: 'list_requests'
  delete 'attendances/leaave_request/:request_id/delete', to: 'attendances#delete_request', as: 'delete_request'
  get 'attendances/leave_request/:request_id/read', to: 'attendances#read_request', as: 'read_request'
  get 'attendances/:district/scan/:attendance_id', to: 'attendances#scan_id', as: 'scan_id'
  get 'attendances/:district', to: 'attendances#history', as: 'all_history'
  post 'attendances/:district/new_date', to: 'attendances#new_date', as: 'new_date'
  get 'attendances/:district/:attendance_id/show_list', to: 'attendances#attendance_list', as: 'attendance_list'
  get 'attendances/:district/:attendance_id/show_list/:student_id', to: 'attendances#edit_description', as: 'edit_description'
  get 'attendances/:district/:attendance_id/show_list/:student_id/edit_note', to: 'attendances#edit_note', as: 'edit_note'
  get 'attendancs/:district/:attendance_id/show_list/:student_id/update_note', to: 'attendances#update_note', as: 'update_note'
  delete 'attendances/:district/:attendance_id/delete_date', to: 'attendances#delete_date', as: 'delete_date'
  get 'attendances/:district/:attendance_id/upload_list', to: 'attendances#upload_list', as: 'upload_list'
  resources :attendances
 
  # get 'download', :to => 'homeworks#download'

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
