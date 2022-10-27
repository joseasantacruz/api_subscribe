require 'json'
class App
  def call(env)
    details_text = ''
    taxes = 0
    total = 0
    req = Rack::Request.new(env)
    body = JSON.parse env['rack.input'].read
    if req.path_info =~ /purchase/
      body['purchase_details'].each do |purchase_detail|
        current_tax = (((get_product_tax(purchase_detail) * purchase_detail['price']).to_f / 100) * 20).round / 20.0
        current_tax = (current_tax * purchase_detail['count'])
        current_price = ((purchase_detail['price'] * purchase_detail['count']) + current_tax).round(2)
        purchase_detail['price'] = current_price
        taxes += current_tax
        total += current_price
        details_text << "#{purchase_detail['count'].to_s}#{purchase_detail['is_imported'] ? ' imported ' : ' '}#{purchase_detail['product_name']}: #{purchase_detail['price'].to_s}\n"
      end
      details_text << "Sales Taxes: #{taxes.round(2).to_s}\n"
      details_text << "Total: #{total.round(2).to_s}"
      ['200', { 'Content-Type' => 'text/json' }, [details_text]]
    else
      ['404', { 'Content-Type' => 'text/json' }, ['Incorrect path.']]
    end
  end

  def get_product_tax(purchase)
    tax = 0
    products = [
      { "name": 'book', "is_imported": false, "tax": 0 },
      { "name": 'music CD', "is_imported": false, "tax": 10 },
      { "name": 'chocolate bar', "is_imported": false, "tax": 0 },
      { "name": 'box of chocolates', "is_imported": false, "tax": 0 },
      { "name": 'bottle of perfume', "is_imported": false, "tax": 10 },
      { "name": 'packet of headache pills', "is_imported": false, "tax": 0 },
      { "name": 'book', "is_imported": true, "tax": 5 },
      { "name": 'music CD', "is_imported": true, "tax": 15 },
      { "name": 'chocolate bar', "is_imported": true, "tax": 5 },
      { "name": 'box of chocolates', "is_imported": true, "tax": 5 },
      { "name": 'bottle of perfume', "is_imported": true, "tax": 15 },
      { "name": 'packet of headache pills', "is_imported": true, "tax": 5 }
    ]
    # search the product to find the tax
    products.each do |product|
      next unless (product[:name] == purchase['product_name']) && (product[:is_imported] == purchase['is_imported'])

      tax = product[:tax]
      break
    end
    tax
  end
end
run App.new