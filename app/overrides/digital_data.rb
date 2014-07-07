Deface::Override.new(:virtual_path => 'spree/shared/_head',
        :name => 'digital_data',
        :insert_after => "title",
        :text => '<script>

            var digitalData = {
		pageInstanceID: "<%= request.url.hash %>",
		page: {
		  pageInfo: {
		    pageID: "<%= request.url.hash %>",
		    pageName: document.title,
		    destinationURL: "<%= request.url %>",
		    referringURL: "<%= request.referer %>",
		    sysEnv: "<%= request.env[\'HTTP_USER_AGENT\'] %>"
		  }
		}
	    };
            <% if @product %>
             digitalData.product = [{
               productInfo: {
                 productID: "<%= @product.id %>",
                 productName: "<%= @product.name %>",
                 description: "<%= @product.description %>",
                 productURL: "<%= request.url %>",
                 sku: "<%= @product.master.sku %>"
               },
               category: {
                 primaryCategory: "<%= @product.tax_category.name if @product.tax_category %>"
               }
             }]

             <% if @product_properties %>
               digitalData.product[0].attributes = {};
               <% @product_properties.each do |property| %>
                    digitalData.product[0].attributes["<%= property.property.presentation %>"] = "<%= property.value %>";
               <% end %>
             <% end %>

             <% if @product.images && @product.images.length >0 %>
               <% image = @product.images[0] %>
               digitalData.product[0]["productInfo"]["productImage"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:product) %>"
               digitalData.product[0]["productInfo"]["productThumbnail"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:mini) %>"
             <% end %>

            <% end %>
            <% cart_order = simple_current_order %>
            <% if cart_order && !flash[:order_completed]%>
              digitalData.cart = {
                cartID: <%= cart_order.id %>,
                price: {
                    basePrice: <%= cart_order.item_total.to_f %>,
                    currency: "<%= cart_order.currency %>",
                    cartTotal: <%= cart_order.total.to_f %>
                },
                itemCount: <%= cart_order.item_count %>,
                item: []
              }
              <% cart_order.line_items.each do |line_item| %>
                <% product = line_item.product %>
                var item = {
                    productInfo: {
                      productID: "<%= product.id %>",
                      productName: "<%= product.name %>",
                      description: "<%= product.description %>",
                      sku: "<%= product.sku %>",
                      productURL: "<%= product_path(product) %>"
                    },

                    category: {
                      primaryCategory: "<%= product.tax_category.name if product.tax_category %>"
                    },
                    quantity: <%= line_item.quantity %>,
                    price: {
                      basePrice: <%= line_item.price.to_f %>,
                      currency: "<%= line_item.currency %>",
                      priceWithTax: <%= line_item.price.to_f %>
                    }
                }

                <% if product.images && product.images.length >0 %>
                  <% image = product.images[0] %>
                    item["productInfo"]["productImage"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:product) %>"
                    item["productInfo"]["productThumbnail"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:mini) %>"
                <% end %>
                digitalData.cart.item.push(item)

              <% end %>
            <% end %>
            <% if flash[:commerce_tracking] %>
                digitalData.transaction = {
                  transactionID: "<%= @order.number %>",
                  profile: {
                    profileInfo: {
                      profileID: "<%= @order.user_id %>",
                      email: "<%= @order.email %>"
                    },
                    address: {
                      line1: "<%= @order.billing_address.address1 %>",
                      line2: "<%= @order.billing_address.address2 %>",
                      city: "<%= @order.billing_address.city %>",
                      stateProvince: "<%= @order.billing_address.state.name %>",
                      postalCode: "<%= @order.billing_address.zipcode %>",
                      country: "<%= @order.billing_address.country.name %>",
                      firstname: "<%= @order.billing_address.firstname %>",
                      lastname: "<%= @order.billing_address.lastname %>",
                    },
                    shippingAddress: {
                      line1: "<%= @order.shipping_address.address1 %>",
                      line2: "<%= @order.shipping_address.address2 %>",
                      city: "<%= @order.shipping_address.city %>",
                      stateProvince: "<%= @order.shipping_address.state.name %>",
                      postalCode: "<%= @order.shipping_address.zipcode %>",
                      country: "<%= @order.shipping_address.country.name %>",
                      firstname: "<%= @order.shipping_address.firstname %>",
                      lastname: "<%= @order.shipping_address.lastname %>",
                    }
                  },
                  total: {
                    basePrice: <%= @order.item_total.to_f %>,
                    currency: "<%= @order.currency %>",
		    shipping: <%= @order.shipment_total.to_f %>,
		    tax: <%= @order.additional_tax_total.to_f %>,
                    transactionTotal: <%= @order.total.to_f %>
                  },
                  itemCount: <%= @order.item_count %>,
                  item: []
                }

                <% @order.line_items.each do |line_item| %>
                    <% product = line_item.product %>
                    var item = {
                        productInfo: {
                          productID: "<%= line_item.variant_id %>",
                          productName: "<%= product.name %>",
                          description: "<%= product.description %>",
                          sku: "<%= product.sku %>",
                          productURL: "<%= product_path(product) %>"
                        },

                        category: {
                          primaryCategory: "<%= product.tax_category.name if product.tax_category %>"
                        },
                        quantity: <%= line_item.quantity %>,
                        price: {
                          basePrice: <%= line_item.price.to_f %>,
                          currency: "<%= line_item.currency %>",
                          priceWithTax: <%= line_item.price.to_f %>
                        }
                    }

                    <% if product.images && product.images.length >0 %>
                      <% image = product.images[0] %>
                        item["productInfo"]["productImage"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:product) %>"
                        item["productInfo"]["productThumbnail"] = "<%= request.protocol + request.host_with_port %><%= image.attachment.url(:mini) %>"
                    <% end %>
                    digitalData.transaction.item.push(item)

                <% end %>


            <% end %>

            <% if spree_current_user %>
                <% current_user = spree_current_user %>
                digitalData.user = [{
                    segment: {
                        current_sign_in_ip: "<%= current_user.current_sign_in_ip %>",
                        last_sign_in_ip: "<%= current_user.last_sign_in_ip %>",
                        sign_in_count: "<%= current_user.sign_in_count %>"
                    },
                    profile: [{
                        profileInfo: {
                            profileID: "<%= current_user.id %>",
                            email: "<%= current_user.email %>"
                        }
			<% if current_user.billing_address %>
			,
                        address: {
                          line1: "<%= current_user.billing_address.address1 %>",
                          line2: "<%= current_user.billing_address.address2 %>",
                          city: "<%= current_user.billing_address.city %>",
                          stateProvince: "<%= current_user.billing_address.state.name %>",
                          postalCode: "<%= current_user.billing_address.zipcode %>",
                          country: "<%= current_user.billing_address.country.name %>",
                          firstname: "<%= current_user.billing_address.firstname %>",
                          lastname: "<%= current_user.billing_address.lastname %>",
                        }
			<% end %>
			<% if current_user.shipping_address %>
			,
                        shippingAddress: {
                          line1: "<%= current_user.shipping_address.address1 %>",
                          line2: "<%= current_user.shipping_address.address2 %>",
                          city: "<%= current_user.shipping_address.city %>",
                          stateProvince: "<%= current_user.shipping_address.state.name %>",
                          postalCode: "<%= current_user.shipping_address.zipcode %>",
                          country: "<%= current_user.shipping_address.country.name %>",
                          firstname: "<%= current_user.shipping_address.firstname %>",
                          lastname: "<%= current_user.shipping_address.lastname %>",
                        }
			<% end %>
                    }]
                }]
            <% end %>
        </script>
<script type="text/javascript">
  (function() {
    if ( document.addEventListener ) {
      document.addEventListener( "DOMContentLoaded", function(){
        document.removeEventListener( "DOMContentLoaded", arguments.callee, false );
          $("#add-to-cart-button").click(function(event){
            event.preventDefault();
            event.stopPropagation();
            var quantity = $("#quantity").val();
            var propertyMap = {quantity: quantity};
                for(var attr in digitalData.product[0].attributes){
                   propertyMap[pm__convertToUnderscore(attr)] = digitalData.product[0].attributes[attr];
                }
                for(var attr in digitalData.product[0].category){
                  propertyMap[pm__convertToUnderscore(attr)] = digitalData.product[0].category[attr];
                }
                for(var attr in digitalData.product[0].productInfo){
                  propertyMap[pm__convertToUnderscore(attr)] = digitalData.product[0].productInfo[attr];
                }
                window._snaq.push(["trackUnstructEvent", "add_to_cart", propertyMap, custom_context]);
            setTimeout(function(){
              $(event.currentTarget).closest("form").submit();
            }, 800);
            return false;
          });

          $("#search-bar input[type=submit]").click(function(event){
            event.preventDefault();
            event.stopPropagation();
            var keywords = $("#keywords").val();
            window._snaq.push(["trackStructEvent", "Ecomm", "search", "Search on topbar", "keywords", keywords, custom_context]);
            setTimeout(function(){
                      $(event.currentTarget).closest("form").submit();
                    }, 800);
            return false;
          });
        }, false );
    }
  })();
</script>
<!-- Snowplow stops plowing -->
	'
)

