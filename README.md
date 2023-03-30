# Ada Numbers

Same as Ada.Numbers, but for Ruby folks :D

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ada_numbers'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ada_numbers

## Usage

## Features:
- It converts a number to its equivalent in written words, i.e. 123 to "cento e vinte três" or 123 to
  "one hundred and twenty-three" depending on the chosen language;
- It converts a word to its equivalent in number, i.e. "cento e vinte dois" to "122" or "one hundred and twenty-two"
  to "122".

**Note: `ada.numbers` supports numbers with a maximum of 15 digits.**

### Specification

To use every feature, simply

	requeire 'ada_numbers'

Converters support 2 global parameters:

- Language;
- Scale.

To set the **language**, it is done as follows:

```ruby
# To use english
AdaNumbers::Settings.language = AdaNumbers::Settings::Parameters::LANGUAGES[:en]
# To use portuguese
AdaNumbers::Settings.language = AdaNumbers::Settings::Parameters::LANGUAGES[:pt]
```

To set the **scale**, it is done as follows:

```ruby
# To use short scale
AdaNumbers::Settings.scale = AdaNumbers::Settings::Parameters::SCALES[:short]
# To use long scale
AdaNumbers::Settings.scale = AdaNumbers::Settings::Parameters::SCALES[:long]
```

To learn more about scales, read [this](https://en.wikipedia.org/wiki/Long_and_short_scales).

The Settings are global, meaning that once they are set, every operation is affected, so, in order to
have a different behavior, the Settings must be explicitly set.
Per default, Language is **Portuguese** and the Scale is **Long**.

To convert **number to words**, use `.to_n` or `.to_number` or using the class methods directly (less recommended):

```ruby
AdaNumbers::WordsToNumberConverter::En.convert "two"  # > 2
AdaNumbers::WordsToNumberConverter::Pt.convert "Dois" # > 2
```

Examples:

```ruby
number = "vinte e dois"
number.to_n # > 22

AdaNumbers::Settings.language = AdaNumbers::Settings::Parameters::LANGUAGES[:en] # converters will now use english
number = "twenty-two"
number.to_n #> "22"
```

To convert **number to words**, use `.to_w` or `.to_words` or using the class methods directly (less recommended):

```ruby
AdaNumbers::NumberToWordsConverter::En.convert 2 # > "Two"
AdaNumbers::NumberToWordsConverter::Pt.convert 2 # > "Dois"
```

```ruby
number = 22;
number.to_w # > "Vinte e Dois"

AdaNumbers::Settings.language = AdaNumbers::Settings::Parameters::LANGUAGES[:en] # converters will now use english
number = 22;
number.to_w #> "Twenty-two"
```

If, for some reason, whichever object your trie to convert is invalid for the converters,
`Message::INVALID_NUMER` will be returned.

Some utilities are also available, such as:

- `.number_of_digits` to know the number of digits of a number

```ruby
number = 22;
number.number_of_digits #> 2
```

- `.category` to know the category of the number.

```ruby
number = 22;
number.category #> NumberCategory::Ten
```

`NumberCategory` is an enum, check its documentation for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test`
to run the tests. You can also run `bin/console` for an interactive prompt that will allow
you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a
new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/roberwil/ada_numbers_gem.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [code of conduct](https://github.com/roberwil/ada_numbers_gem/blob/main/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the AdaNumbers project's codebases, issue trackers, chat rooms and
mailing lists is expected to follow the [code of conduct](https://github.com/roberwil/ada_numbers_gem/blob/main/CODE_OF_CONDUCT.md).
