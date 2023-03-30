require_relative './pt/words_to_number_converter'
require_relative './en/words_to_number_converter'

class String
  def to_number
    case AdaNumbers::Settings.language
    when AdaNumbers::Settings::Parameters::LANGUAGES[:en]
      AdaNumbers::WordsToNumberConverter::En.convert self
    else
      AdaNumbers::WordsToNumberConverter::Pt.convert self
    end
  end

  def to_n
    to_number
  end
end
