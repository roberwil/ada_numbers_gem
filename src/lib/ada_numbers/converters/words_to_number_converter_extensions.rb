require_relative './pt/number_to_words_converter'
require_relative './en/number_to_words_converter'

class String
  def to_number
    case AdaNumbers::Settings.language
    when AdaNumbers::Settings::Parameters::LANGUAGES[:en]
      #AdaNumbers::WordsToNumberConverter::En.convert self
    else
      AdaNumbers::WordsToNumberConverter::Pt.convert self
    end
  end

  def to_n
    to_number
  end
end
