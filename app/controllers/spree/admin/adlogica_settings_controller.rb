require 'spree'
require 'spree/core/controller_helpers/store'
module Spree
  module Admin
    class AdlogicaSettingsController < Spree::Admin::BaseController
      before_filter :set_store
      include Spree::Core::ControllerHelpers::Store

      def edit
      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end
	current_store.update_attributes store_params
	
        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:adlogica_settings))
        redirect_to edit_admin_adlogica_settings_path
      end

      def dismiss_alert
        if request.xhr? and params[:alert_id]
          dismissed = Spree::Config[:dismissed_spree_alerts] || ''
          Spree::Config.set :dismissed_spree_alerts => dismissed.split(',').push(params[:alert_id]).join(',')
          filter_dismissed_alerts
          render :nothing => true
        end
      end

      private
      def store_params
        params.require(:store).permit(permitted_params)
      end

      def permitted_params
        return [:org_id, :app_id]  
      end

      def set_store
        @store = current_store
      end
    end
  end
end
