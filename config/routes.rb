Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  Spree::Core::Engine.routes.draw do
    get "/adlogica_extension_installed" => "adlogica#is_configured"
  end
  namespace :admin do
    resource :adlogica_settings do
      collection do
        post :dismiss_alert
      end
    end
  end
end
