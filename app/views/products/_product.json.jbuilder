json.extract! product, :id, :product_name, :price, :shipping, :link, :created_at, :updated_at
json.url product_url(product, format: :json)
