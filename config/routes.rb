Rottenpotatoes::Application.routes.draw do
  resources :movies do
    match "same_director" => "movies#same_director"
  end
end
