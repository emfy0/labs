module BoyerMoore
  def self.search(haystack, needle_string)
    needle = Needle.new(needle_string)

    haystack_index = 0
    while haystack_index <= haystack.size - needle.size
      break haystack_index unless skip_by = needle.match_or_skip_by(haystack, haystack_index)

      haystack_index += skip_by

      # Found a match at haystack_index!

    end
  end

  class Needle
    def initialize(needle)
      needle.size > 0 or raise 'Must pass needle with size > 0'
      @needle = needle
    end

    def size
      @needle.size
    end

    def match_or_skip_by(haystack, haystack_index)
      return unless mismatch_idx = mismatch_index(haystack, haystack_index)

      mismatch_char_index = character_index(haystack[haystack_index + mismatch_idx])
      skip_by(mismatch_char_index, mismatch_idx)
    end

    private

    def mismatch_index(haystack, haystack_index)
      compare_index = size - 1
      while @needle[compare_index] == haystack[haystack_index + compare_index]
        compare_index -= 1
        compare_index < 0 and return nil
      end
      compare_index
    end

    def character_index(char)
      character_indexes[char] || -1
    end

    def good_suffix(compare_index)
      good_suffixes[compare_index]
    end

    def skip_by(mismatch_char_index, compare_index)
      suffix_index = good_suffix(compare_index + 1)
      if mismatch_char_index <= compare_index && (m = compare_index - mismatch_char_index) > suffix_index
        m
      else
        suffix_index
      end
    end

    def character_indexes
      @char_indexes ||=
        (0...@needle.length).each_with_object({}) do |i, hash|
          hash[@needle[i]] = i
        end
    end

    def good_suffixes
      @good_suffixes ||=
        begin
          prefix_normal   = self.class.prefix(@needle)
          prefix_reversed = self.class.prefix(@needle.reverse)
          result = []
          (0..@needle.size).each do |i|
            result[i] = @needle.size - prefix_normal[@needle.size - 1]
          end
          (0...@needle.size).each do |i|
            j = @needle.size - prefix_reversed[i]
            k = i - prefix_reversed[i] + 1
            result[j] > k and result[j] = k
          end
          result
        end
    end

    def self.prefix(string)
      k = 0
      (1...string.length).each_with_object([0]) do |q, prefix|
        k = prefix[k - 1] while k > 0 && string[k] != string[q]
        string[k] == string[q] and k += 1
        prefix[q] = k
      end
    end
  end
end

pp BoyerMoore.search('foobar', 'bar')     # => 3
pp BoyerMoore.search('foobar', 'oof')     # => nil
pp BoyerMoore.search('foobar', 'foo')     # => 0
