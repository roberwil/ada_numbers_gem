require_relative './pt/number_to_words_converter'
require_relative './en/number_to_words_converter'

class String
  def to_number
    AdaNumbers::WordsToNumberConverter::Pt.convert self
  end

  def to_n
    to_number
  end
end
