class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each { |item| ItemUpdateService.new(item).call }
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ItemUpdateService
  MIN_QUALITY = 0
  MAX_QUALITY = 50
  DEFAULT_QUALITY_ADJUSTMENT = 1

  def initialize(item)
    @item = item
  end

  def call
    return if @item.name == 'Sulfuras, Hand of Ragnaros'

    decrease_sell_in
    update_quality
    validate_quality
  end

  def update_quality
    adjustment = DEFAULT_QUALITY_ADJUSTMENT
    adjustment *= 2 if @item.sell_in < 0

    case @item.name
    when 'Aged Brie'
      @item.quality += adjustment
    when 'Backstage passes to a TAFKAL80ETC concert'
      if @item.sell_in >= 0
        adjustment += 1 if @item.sell_in < 10
        adjustment += 1 if @item.sell_in < 5
        @item.quality += adjustment
      else
        @item.quality = 0
      end
    when 'Conjured Mana Cake'
      adjustment *= 2
      @item.quality -= adjustment
    else
      @item.quality -= adjustment
    end
  end

  def decrease_sell_in
    @item.sell_in -= 1
  end

  def validate_quality
    @item.quality = MIN_QUALITY if @item.quality < MIN_QUALITY
    @item.quality = MAX_QUALITY if @item.quality > MAX_QUALITY
  end
end
