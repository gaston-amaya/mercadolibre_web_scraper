class ProductsSpider < Kimurai::Base
    @name = "products_spider"
    @engine = :mechanize
    
  
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end
  
    def parse(response, url:, data: {})
      response.xpath("//div[@class='andes-card andes-card--flat andes-card--default ui-search-result ui-search-result--core andes-card--padding-default andes-card--animated']").each do |product|
        item = {}
        
  
        item[:product_name] = product.xpath("//h2[@class='ui-search-item__title ui-search-item__group__element']")&.text&.squish
        item[:price] = product.xpath("//span[@class='price-tag-fraction']")&.text&.squish&.delete('^0-9')to_i
        item[:shipping] = product.xpath("//p[@class='ui-search-item__shipping ui-search-item__shipping--free']")&.text&.squish
  
        
        Product.where(item).first_or_create
      end
    end
  end