class AddAppIdToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :app_id, :string
  end
end
