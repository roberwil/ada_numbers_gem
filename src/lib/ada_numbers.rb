require 'ada_numbers/version'

require 'ada_numbers/converters/number_to_words_converter_extensions'
require 'ada_numbers/converters/pt/number_to_words_converter'
require 'ada_numbers/converters/en/number_to_words_converter'

require 'ada_numbers/converters/words_to_number_converter_extensions'
require 'ada_numbers/converters/pt/words_to_number_converter'

module AdaNumbers
  class Error < StandardError; end
  # Your code goes here...
end
