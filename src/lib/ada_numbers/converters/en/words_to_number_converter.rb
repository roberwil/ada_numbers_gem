require_relative '../../utilities/integer_extensions'
require_relative '../../utilities/hash_extensions'
require_relative '../../utilities/string_extensions'
require_relative '../../utilities/settings'
require_relative '../../utilities/number_category'

require_relative '../../constants/en/written_numbers'
require_relative '../../constants/en/separators'
require_relative '../../constants/message'

module AdaNumbers
  module WordsToNumberConverter
    class En
      @@use_short_scale = false

      def self.convert(word)
        select_scale

        word = word.gsub(/\s+/, ' ').strip.
          gsub(Separator::En::DASH, " #{Separator::En::NUMBERS_SEPARATOR} ").
          gsub(Separator::En::COMMA, '').
          title_case

        words_to_convert = word.split " #{Separator::En::DECIMAL_SEPARATOR} "
        words_to_convert = word.split " #{Separator::En::DECIMAL_SEPARATOR_ALTERNATIVE} " if words_to_convert.size == 1

        case words_to_convert.size
        when 1
          return resolve_word word, @@use_short_scale
        when 2
          count_zeros = words_to_convert.last.split(' ').select { |w| w == WrittenNumber::En::ZERO }.size

          whole_part = resolve_word words_to_convert.first, @@use_short_scale
          decimal_part = resolve_word words_to_convert.last.gsub(WrittenNumber::En::ZERO, ""), @@use_short_scale

          return Message::INVALID_NUMBER if whole_part == Message::INVALID_NUMBER || decimal_part == Message::INVALID_NUMBER

          decimal_part = "#{'0' * count_zeros}#{decimal_part}" if count_zeros > 0
          number = "#{whole_part}.#{decimal_part}"

          return number.to_f
        end

        return Message::INVALID_NUMBER
      end

      private

      def self.resolve_word(word, use_short_scale = false)
        word = word.gsub /\s+/, ' '

        # Try to get a direct match from the map
        number = map_number_according_to_scale word, use_short_scale
        return number unless number.nil?

        # It was not found a direct match, so, let's find that bastard
        string_tokens = word.split ' '
        numeric_tokens = []

        # The algorithm consists on iterating every token so that to find its direct match
        # in the map and then stack it up. If the next number to be stacked requires a multiplier,
        # we find it and stack it up after popping the later numbers. When all the matches are found
        # The number is their sum
        (0...string_tokens.size).each do |cursor|
          token = string_tokens[cursor]

          case token
          when token == Separator::En::NUMBERS_SEPARATOR && (cursor == 0 || cursor == string_tokens.size - 1),
            token == Separator::En::NUMBERS_SEPARATOR && WrittenNumber::En.numbers_that_ignore_separator.include?(string_tokens[cursor + 1]),
            token == Separator::En::NUMBERS_SEPARATOR && cursor > 0 && string_tokens[cursor - 1] == Separator::En::NUMBERS_SEPARATOR
            return Message::INVALID_NUMBER
          when Separator::En::NUMBERS_SEPARATOR
            next
          end

          number_has_incorrect_or_no_separator =
            # cursor is valid for evaluation
            cursor > 0 && (cursor + 1 < string_tokens.size - 1) &&
            # number is not part of number that ignore separator nor its next neighbour
            !WrittenNumber::En.numbers_that_ignore_separator.include?(token) &&
            !WrittenNumber::En.numbers_that_ignore_separator.include?(string_tokens[cursor + 1]) &&
            !WrittenNumber::En.unities_that_combine_with_separator.include?(token) &&
            string_tokens[cursor - 1] != Separator::En::NUMBERS_SEPARATOR

          number_is_in_incorrect_short_scale_format = use_short_scale && cursor > 0 &&
            cursor < string_tokens.size - 1 && token == WrittenNumber::En::THOUSAND &&
            WrittenNumber::En.not_to_combine_with_thousand.include?(string_tokens[cursor + 1])

          return Message::INVALID_NUMBER if number_has_incorrect_or_no_separator || number_is_in_incorrect_short_scale_format

          number = map_number_according_to_scale token, use_short_scale
          return Message::INVALID_NUMBER if number.nil?

          if compute_multiplier? token, numeric_tokens.size
            multiplier, numeric_tokens = find_multiplier numeric_tokens
            number *= multiplier
          end

          numeric_tokens.push number
        end

        numeric_tokens.sum
      end

      def self.map_number_according_to_scale(word, use_short_scale)
        mapped_number = WrittenNumber::En.words_to_number_map.resolve(word)

        number = if use_short_scale
                   mapped_number.nil? ? WrittenNumber::En.words_to_number_map_short_scale.resolve(word) : mapped_number
                 else
                   mapped_number.nil? ? WrittenNumber::En.words_to_number_map_long_scale.resolve(word) : mapped_number
                 end

        number
      end

      def self.select_scale
        @@use_short_scale = Settings.scale == Settings::Parameters::SCALES[:short]
      end

      def self.compute_multiplier?(token, number_of_numeric_tokes)
        (token == WrittenNumber::En::HUNDRED ||
          token == WrittenNumber::En::MILLION ||
          token == WrittenNumber::En::BILLION ||
          token == WrittenNumber::En::TRILLION) &&
          number_of_numeric_tokes != 0
      end

      def self.find_multiplier(numeric_tokens)
        multiplier = numeric_tokens.pop

        while numeric_tokens.size != 0
          maybe_number = numeric_tokens.pop
          break if maybe_number.nil?

          number = maybe_number.to_i

          if number.category > NumberCategory::HUNDRED
            numeric_tokens.push(number)
            break
          end

          multiplier += number
        end

        return multiplier, numeric_tokens
      end
    end
  end
end
