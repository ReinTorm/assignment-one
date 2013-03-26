# Yout little input goes here!
require 'rubygems' 
require 'json' 

class Item  
  attr_accessor :name, :size, :color, :category, :in_store, :available, :price 
  def initialize(options = {})
     @name = options['name']
     @category = options['category']
     @color = options['color']
     @size = options['size']
     @price = options['price']
     @in_store = options['in_store']
  end
end

class Store
  attr_accessor :total_sale
  def initialize  
     @items = []
     @total_sale = 0 
  end
  

  def total_sale 
     @total_sale.round(2)
  end
  def import_items(file) 
     json_data = File.read(file) 
     JSON.parse(json_data).each do |data|
       @items << Item.new(data)
     end
  end
 


  def search(params) 
     items = @items
     params.each do |k, v|
       if k == :available
          items = items.select { |item| item.in_store > 0} 
      
       else
          items = items.select { |item| item.send(k).to_s.downcase == v.to_s.downcase }
       end
    end
     items
  end 

  def items_sorted_by(symbol, order) 
     if order == :asc
       @items.sort! {|a, b| a.send(symbol) <=> b.send(symbol)}
     else 
       @items.sort! {|a, b| a.send(symbol) <=> b.send(symbol)}.reverse
     end

  end
  
  def categories
     @items.map {|x| x.category}.uniq 
  end
  
  def unique_articles_in_category(article)
     unique_articles = []
     @items.select {|x| x.category == article}.uniq {|item| unique_articles << item.name}.uniq
     unique_articles.uniq
  end
    
    
end   

class Store::Cart  
  attr_accessor :store, :items, :total_cost, :total_items
  def initialize(store)
     @store = store 
     @items = [] 
     @total_cost = 0.0
     @total_items = 0
  end

  def total_cost 
     @total_cost.round(2)
  end  

  def add_item(item, num = 1)
     new_number = 0 
     if item.in_store >= num 
       num.times do 
   @items << item
         item.in_store -= 1
         @total_cost += item.price
       end
     elsif item.in_store <= num
       new_number = item.in_store 
       new_number.times do 
         @items << item
         @total_cost += item.price  
       end
     end
      @total_items += num  
  end
  
  def unique_items 
     @items.uniq
  end 
 
  def checkout!
     @items = [] 
     @total_items = 0  
     store.total_sale += @total_cost 
     @total_cost = 0.0
  end

end 
