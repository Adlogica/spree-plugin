Deface::Override.new(:virtual_path => 'spree/admin/shared/_configuration_menu',
  :name => "add_adlogica_configuration_to_sidemenu",
  :insert_top => "ul.sidebar",
  :partial => "spree/admin/shared/adlogica_configuration_menu"
)
