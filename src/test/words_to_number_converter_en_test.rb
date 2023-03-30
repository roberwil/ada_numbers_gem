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

  describe "Unities" do
    [
      [0, "Zero"],
      [1, "One"],
      [2, "Two"],
      [3, "Three"],
      [4, "Four"],
      [5, "Five"],
      [6, "Six"],
      [7, "Seven"],
      [8, "Eight"],
      [9, "Nine"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Tens" do
    [
      [10, "Ten"],
      [11, "Eleven"],
      [12, "Twelve"],
      [13, "Thirteen"],
      [14, "Fourteen"],
      [15, "Fifteen"],
      [16, "Sixteen"],
      [17, "Seventeen"],
      [18, "Eighteen"],
      [19, "Nineteen"],
      [20, "Twenty"],
      [21, "Twenty-one"],
      [30, "Thirty"],
      [32, "Thirty-two"],
      [40, "Forty"],
      [43, "Forty-three"],
      [50, "Fifty"],
      [54, "Fifty-four"],
      [60, "Sixty"],
      [65, "Sixty-five"],
      [70, "Seventy"],
      [76, "Seventy-six"],
      [80, "Eighty"],
      [87, "Eighty-seven"],
      [90, "Ninety"],
      [98, "Ninety-eight"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Hundreds" do
    [
      [100, "One Hundred"],
      [101, "One Hundred and One"],
      [111, "One Hundred and Eleven"],
      [121, "One Hundred and Twenty-one"],
      [200, "Two Hundred"],
      [202, "Two Hundred and Two"],
      [212, "Two Hundred and Twelve"],
      [222, "Two Hundred and Twenty-two"],
      [300, "Three Hundred"],
      [303, "Three Hundred and Three"],
      [313, "Three Hundred and Thirteen"],
      [333, "Three Hundred and Thirty-three"],
      [400, "Four Hundred"],
      [404, "Four Hundred and Four"],
      [414, "Four Hundred and Fourteen"],
      [444, "Four Hundred and Forty-four"],
      [500, "Five Hundred"],
      [505, "Five Hundred and Five"],
      [515, "Five Hundred and Fifteen"],
      [555, "Five Hundred and Fifty-five"],
      [600, "Six Hundred"],
      [606, "Six Hundred and Six"],
      [616, "Six Hundred and Sixteen"],
      [666, "Six Hundred and Sixty-six"],
      [700, "Seven Hundred"],
      [707, "Seven Hundred and Seven"],
      [717, "Seven Hundred and Seventeen"],
      [777, "Seven Hundred and Seventy-seven"],
      [800, "Eight Hundred"],
      [808, "Eight Hundred and Eight"],
      [818, "Eight Hundred and Eighteen"],
      [888, "Eight Hundred and Eighty-eight"],
      [900, "Nine Hundred"],
      [909, "Nine Hundred and Nine"],
      [919, "Nine Hundred and Nineteen"],
      [999, "Nine Hundred and Ninety-nine"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Thousands" do
    [
      [1000, "One Thousand"],
      [1001, "One Thousand and One"],
      [1011, "One Thousand and Eleven"],
      [1111, "One Thousand, One Hundred and Eleven"],
      [10000, "Ten Thousand"],
      [10001, "Ten Thousand and One"],
      [34001, "Thirty-four Thousand and One"],
      [140000, "One Hundred, Forty Thousand"],
      [140001, "One Hundred, Forty Thousand and One"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Millions" do
    [
      [1000000, "One Million"],
      [1000001, "One Million and One"],
      [1000011, "One Million and Eleven"],
      [1000022, "One Million and Twenty-two"],
      [1000122, "One Million, One Hundred and Twenty-two"],
      [2000122, "Two Million, One Hundred and Twenty-two"],
      [20000122, "Twenty Million, One Hundred and Twenty-two"],
      [22000122, "Twenty-two Million, One Hundred and Twenty-two"]
    ].each do |test_set|
      to_convert, expected = explode test_set
      select_scale :long

      it "#{to_convert} should be '#{expected}'" do
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Thousand Millions" do
    [
      [1000000000, "One Thousand Million"],
      [1000000001, "One Thousand Million and One"],
      [1000000011, "One Thousand Million and Eleven"],
      [1000000022, "One Thousand Million and Twenty-two"],
      [1000000122, "One Thousand Million, One Hundred and Twenty-two"],
      [2000000122, "Two Thousand Million, One Hundred and Twenty-two"],
      [20000000122, "Twenty Thousand Million, One Hundred and Twenty-two"],
      [22000000122, "Twenty-two Thousand Million, One Hundred and Twenty-two"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :long
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Thousand Millions in short scale (billions)" do
    [
      [1000000000, "One Billion"],
      [1000000001, "One Billion and One"],
      [1000000011, "One Billion and Eleven"],
      [1000000022, "One Billion and Twenty-two"],
      [1000000122, "One Billion, One Hundred and Twenty-two"],
      [2000000122, "Two Billion, One Hundred and Twenty-two"],
      [20000000122, "Twenty Billion, One Hundred and Twenty-two"],
      [22000000122, "Twenty-two Billion, One Hundred and Twenty-two"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :short
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Billions" do
    [
      [1000000000000, "One Billion"],
      [1000000000001, "One Billion and One"],
      [1000000000011, "One Billion and Eleven"],
      [1000000000022, "One Billion and Twenty-two"],
      [1000000000122, "One Billion, One Hundred and Twenty-two"],
      [2000000000122, "Two Billion, One Hundred and Twenty-two"],
      [20000000000122, "Twenty Billion, One Hundred and Twenty-two"],
      [22000000000122, "Twenty-two Billion, One Hundred and Twenty-two"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :long
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Billions in short scale (trillions)" do
    [
      [1000000000000, "One Trillion"],
      [1000000000001, "One Trillion and One"],
      [1000000000011, "One Trillion and Eleven"],
      [1000000000022, "One Trillion and Twenty-two"],
      [1000000000122, "One Trillion, One Hundred and Twenty-two"],
      [2000000000122, "Two Trillion, One Hundred and Twenty-two"],
      [20000000000122, "Twenty Trillion, One Hundred and Twenty-two"],
      [22000000000122, "Twenty-two Trillion, One Hundred and Twenty-two"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :short
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Random integers" do
    [
      [42, "Forty-two"],
      [102, "One Hundred and Two"],
      [113, "One Hundred and Thirteen"],
      [123, "One Hundred and Twenty-three"],
      [902, "Nine Hundred and Two"],
      [99, "Ninety-nine"],
      [999, "Nine Hundred and Ninety-nine"],
      [1000, "One Thousand"],
      [1123, "One Thousand, One Hundred and Twenty-three"],
      [30000, "Thirty Thousand"],
      [10123, "Ten Thousand, One Hundred and Twenty-three"],
      [21123, "Twenty-one Thousand, One Hundred and Twenty-three"],
      [100000, "One Hundred Thousand"],
      [100123, "One Hundred Thousand, One Hundred and Twenty-three"],
      [112123, "One Hundred, Twelve Thousand, One Hundred and Twenty-three"],
      [134123, "One Hundred, Thirty-four Thousand, One Hundred and Twenty-three"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :long
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

  describe "Random decimals" do
    [
      [42.2, "Forty-two point Two"],
      [102.0, "One Hundred and Two"],
      [103.000, "One Hundred and Three"],
      [113.02, "One Hundred and Thirteen point Zero Two"],
      [123.0045, "One Hundred and Twenty-three point Zero Zero Forty-five"],
      [902.982, "Nine Hundred and Two point Nine Hundred and Eighty-two"],
      [100000.001, "One Hundred Thousand point Zero Zero One"],
      [100123.100123, "One Hundred Thousand, One Hundred and Twenty-three point One Hundred Thousand, One Hundred and Twenty-three"]
    ].each do |test_set|
      to_convert, expected = explode test_set

      it "#{to_convert} should be '#{expected}'" do
        select_scale :long
        actual = to_convert.to_n
        assert_equal expected, actual
      end
    end
  end

end
