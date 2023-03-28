require_relative '../../utilities/integer_extensions'
require_relative '../../utilities/hash_extensions'
require_relative '../../utilities/settings'
require_relative '../../utilities/number_category'

require_relative '../../constants/en/written_numbers'
require_relative '../../constants/en/separators'
require_relative '../../constants/message'

module AdaNumbers
  module NumberToWordsConverter
    class En
      @@use_short_scale = false
      @@number_tokens = []

      def self.convert(number)
        return convert_integer(number) if number.class == Integer
        return convert_float(number)
      end

      private
      def self.convert_integer(number)
        return Message::UNSUPPORTED if number.number_of_digits > Settings::Parameters::DIGITS_LIMIT

        select_scale
        @@number_tokens.clear
        return resolve_number number
      end

      def self.convert_float(number)
        select_scale

        str_number = number.to_s.split '.'

        str_integer_part = str_number.first
        str_decimal_part = str_number.size == 1 ? "0" : str_number.last

        return Message::UNSUPPORTED if str_integer_part.size > Settings::Parameters::DIGITS_LIMIT || str_decimal_part.size > Settings::Parameters::DIGITS_LIMIT

        whole_part = str_integer_part.to_i
        decimal_part = str_decimal_part.to_i

        @@number_tokens.clear
        result = resolve_number whole_part

        return result if decimal_part == 0

        result += " #{Separator::En::DECIMAL_SEPARATOR.downcase} "
        # just aggregating the zeros
        result += str_decimal_part.split('').
          take_while { |c| c == "0" }.
          collect { |c| WrittenNumber::En::ZERO }.
          join ' '

        @@number_tokens.clear
        result += result[-1] == ' ' ? resolve_number(decimal_part) :
                    " #{resolve_number(decimal_part)}"

        return result
      end

      def self.select_scale
        @@use_short_scale = Settings.scale == Settings::Parameters::SCALES[:short]
      end

      def self.resolve_number(number)
        result = ''
        number_category = number.category

        case number_category
        when NumberCategory::UNITY
          result = unities number
        when NumberCategory::TEN
          result = tens number
        when NumberCategory::HUNDRED
          result = hundreds number
        when NumberCategory::THOUSAND
          result = thousands number
        when NumberCategory::MILLION
          result = millions number
        when NumberCategory::THOUSAND_MILLIONS
          result = thousand_millions number
        when NumberCategory::BILLION
          result = billions number
        end

        if result.empty?
          str_number = number.to_s
          bridge = number.bridge

          first_digits = (str_number[0...bridge] + '0' * number_category).to_i
          other_digits = (str_number[bridge..-1]).to_i

          resolve_number first_digits
          resolve_number other_digits
        else
          @@number_tokens << result
        end

        add_separators_to_number @@number_tokens
      end

      def self.unity_or_ten?(number)
        result = WrittenNumber::En.words_to_number_unities_and_tens_map.resolve(number).nil?
        result ? number.include?(Separator::En::DASH) : result
      end

      def self.add_separators_to_number(number_tokens)
        result = number_tokens.first

        (1...number_tokens.size).each do |cursor|
          current_token = number_tokens[cursor]

          is_hundred = cursor + 1 < number_tokens.size && unity_or_ten?(current_token) &&
            (number_tokens[cursor + 1]  == WrittenNumber::En::HUNDRED ||
              number_tokens[cursor + 1] == WrittenNumber::En::THOUSAND ||
              number_tokens[cursor + 1] == WrittenNumber::En::MILLION ||
              number_tokens[cursor + 1] == WrittenNumber::En::THOUSAND_MILLION ||
              number_tokens[cursor + 1] == WrittenNumber::En::BILLION ||
              number_tokens[cursor + 1] == WrittenNumber::En::TRILLION)

          add_comma = cursor > 1 &&
            is_hundred

          no_separator = WrittenNumber::En.numbers_that_ignore_separator.include?(current_token) ||
            is_hundred

          if (add_comma)
            result += "#{Separator::En::COMMA} #{current_token}"
          elsif no_separator
            result += " #{current_token}"
          else
            result += " #{Separator::En::NUMBERS_SEPARATOR.downcase} #{current_token}"
          end
        end

        return result
      end

      def self.unities(number)
        WrittenNumber::En.numbers_to_words_map_unities.resolve number
      end

      def self.tens(number)
        result = WrittenNumber::En.numbers_to_words_map_tens.resolve number
        return result if result != ''

        bridge = number.bridge
        ten    = number.to_s[0...bridge].to_i*10
        unity  = number.to_s[bridge..-1].to_i

        result = "#{tens(ten)}#{Separator::En::DASH}#{unities(unity).downcase}"
        result
      end

      def self.hundreds(number)
        evaluate_hundreds_and_over number, 1e2.to_i, WrittenNumber::En::HUNDRED
      end

      def self.thousands(number)
        evaluate_hundreds_and_over number, 1e3.to_i, WrittenNumber::En::THOUSAND
      end

      def self.millions(number)
        evaluate_hundreds_and_over number, 1e6.to_i, WrittenNumber::En::MILLION
      end

      def self.thousand_millions(number)
        qualifier = (@@use_short_scale ? WrittenNumber::En::BILLION : WrittenNumber::En::THOUSAND_MILLION)
        evaluate_hundreds_and_over number, 1e9.to_i, qualifier
      end

      def self.billions(number)
        qualifier = (@@use_short_scale ? WrittenNumber::En::TRILLION : WrittenNumber::En::BILLION)
        evaluate_hundreds_and_over number, 1e12.to_i, qualifier
      end

      def self.evaluate_hundreds_and_over(number, category_identifier, qualifier)
        return '' if number % category_identifier != 0

        partial_number = number.to_s[0...number.bridge].to_i
        resolve_number partial_number
        return qualifier
      end
    end
  end
end
