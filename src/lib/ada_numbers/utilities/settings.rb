# frozen_string_literal: true

module AdaNumbers
  class Settings
    class Parameters
      LANGUAGES = {
        en: :english,
        pt: :portuguese
      }

      SCALES = {
        short: :short,
        long:  :long
      }

      DIGITS_LIMIT = 15

      @hello = "hi"
      class << self
        attr_accessor :hello
      end
    end

    @language = Parameters::LANGUAGES[:pt]
    @scale    = Parameters::SCALES[:long]

    class << self
      attr_accessor :language, :scale

      def reset
        @language = Parameters::LANGUAGES[:pt]
        @scale    = Parameters::SCALES[:long]
      end
    end
  end
end
