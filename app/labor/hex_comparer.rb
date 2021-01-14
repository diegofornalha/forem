class HexComparer
  RGB_REGEX = /^#?(?<r>..)(?<g>..)(?<b>..)$/.freeze
  ACCENT_MODIFIERS = [1.14, 1.08, 1.06, 0.96, 0.9, 0.8, 0.7, 0.6].freeze

  def initialize(hexes, amount = 1)
    @hexes = hexes.sort
    @amount = amount
  end

  def smallest
    hexes.first
  end

  def biggest
    hexes.last
  end

  def brightness(amount = 1)
    rgb = hex_to_rgb_hash(smallest).transform_values do |color|
      (color * amount).round
    end
    format("#%<r>02x%<g>02x%<b>02x", rgb)
  rescue StandardError
    smallest
  end

  # Returns the first valid hex string it finds (# + 6 digits)
  def accent
    ACCENT_MODIFIERS.each do |modifier|
      with_brightness = brightness(modifier**amount)
      break with_brightness if with_brightness.size == 7
    end
  end

  def opacity(value = 0.0)
    rgba = hex_to_rgb_hash(smallest).merge(a: value)
    format("rgba(%<r>d, %<g>d, %<b>d, %<a>.2f)", rgba)
  end

  private

  def hex_to_rgb_hash(hex)
    hex.match(RGB_REGEX).named_captures.map do |key, color|
      [key.to_sym, color.hex]
    end.to_h
  end

  attr_accessor :hexes, :amount
end