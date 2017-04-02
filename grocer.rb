require 'pry'

def consolidate_cart(cart)
  counts = Hash.new 0
  cart.each do |item_hash|
    counts[item_hash] += 1
  end
  consolidated_cart = Hash.new
  counts.each do |item_hash, count|
    item_hash.each do |item, stats|
      consolidated_cart[item] = stats.merge!({:count => count})
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  coupon_cart = Hash.new
  cart.each do |item, data|
    coupon_cart[item] = data.dup
    coupons.each do |coupon|
      if coupon[:item] == item
        coupon_cart[item][:count] %= coupon[:num]
        coupon_cart[item + " W/COUPON"] = data.dup
        coupon_cart[item + " W/COUPON"][:count] = data[:count] / coupon[:num]
        coupon_cart[item + " W/COUPON"][:price] = coupon[:cost]
      end
    end
  end
  coupon_cart
end

def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] -= data[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  total_cost = 0.0
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  discounted_cart = apply_clearance(couponed_cart)
  discounted_cart.each do |item, data|
    total_cost += data[:price] * data[:count]
  end
  if total_cost > 100.00
    total_cost *= 0.9
  end
  total_cost
end
