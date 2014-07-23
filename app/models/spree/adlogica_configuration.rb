module Spree
  class AdlogicaConfiguration < Preferences::Configuration
    preference :org_id, :string, :default => ""
    preference :app_id, :string, :default => ""
  end
end

