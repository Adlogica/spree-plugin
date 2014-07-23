class AddOrgIdToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :org_id, :string
  end
end
