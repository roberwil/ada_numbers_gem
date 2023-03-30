require_relative './pt/number_to_words_converter'
require_relative './en/number_to_words_converter'

class Float
  def to_words
    case AdaNumbers::Settings.language
    when AdaNumbers::Settings::Parameters::LANGUAGES[:en]
      AdaNumbers::NumberToWordsConverter::En.convert self
    else
      AdaNumbers::NumberToWordsConverter::Pt.convert self
    end
  end

  def to_w
    to_words
  end
end

class Integer
  def to_words
    case AdaNumbers::Settings.language
    when AdaNumbers::Settings::Parameters::LANGUAGES[:en]
      AdaNumbers::NumberToWordsConverter::En.convert self
    else
      AdaNumbers::NumberToWordsConverter::Pt.convert self
    end
  end

  def to_w
    to_words
  end
end
