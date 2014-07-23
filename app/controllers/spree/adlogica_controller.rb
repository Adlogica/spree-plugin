class Spree::AdlogicaController < Spree::StoreController
    def is_configured
      @store = current_store
      if @store.org_id.empty? || @store.app_id.empty?
	respond_to do |format|
          format.json { render json: {"is_configured" => false, "is_installed" => true }, status: 200 }
        end
      else
        respond_to do |format|
          format.json { render json: {"is_configured" => true, "is_installed" => true }, status: 200 }	
        end
      end
    end
end
