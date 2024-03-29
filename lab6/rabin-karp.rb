require 'cityhash'

class String
  def rk_search(substring)
    substring_hash = CityHash.hash64(substring)
    substring_size = substring.size

    each_byte.with_index do |_, i|
      return if i + substring_size > size
      return i if CityHash.hash64(self[i, substring_size]) == substring_hash
    end
  end
end

n         = 50_000
string    = 'hello world'
substring = 'world'

puts string.rk_search('world')
