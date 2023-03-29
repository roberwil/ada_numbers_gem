require "test_helper"

def select_scale(scale)
  AdaNumbers::Settings.scale = AdaNumbers::Settings::Parameters::SCALES[scale]
end

def explode(set)
  return set.last, set.first
end

describe "EN Words-to-number converter is valid for" do

  before do
    AdaNumbers::Settings.language = AdaNumbers::Settings::Parameters::LANGUAGES[:en]
  end
end
