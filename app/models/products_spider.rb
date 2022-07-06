class ProductsSpider < Kimurai::Base
    @name = "products_spider"
    @engine = :mechanize
    
  
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end
  
    def parse(response, url:, data: {})
      response.xpath("//div[@class='ui-search-result__wrapper']").each do |product|
        item = {}
        
  
        item[:product_name] = product.css('h2.ui-search-item__title')&.text&.squish
        item[:price] = product.css('span.price-tag-fraction')&.text&.squish&.delete('^0-9').to_f
        item[:link] = product.css('a')[0].attributes["href"].value
        shipping = product.css('p.ui-search-item__shipping').css('span.ui-search-item__promise__text--last')

        if shipping.length > 15
          item[:shipping] = product.css('span.ui-search-item__promise__text--last')&.text&.squish
        else
          item[:shipping] = product.css('p.ui-search-item__shipping')&.text&.squish
        end
        
        
  
        
        Product.where(item).first_or_create
      end
    end
  end
