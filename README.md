# RSpec-Param

[![Build Status](https://img.shields.io/travis/coderanger/rspec-param.svg)](https://travis-ci.org/coderanger/rspec-param)
[![Gem Version](https://img.shields.io/gem/v/rspec-param.svg)](https://rubygems.org/gems/rspec-param)
[![Coverage](https://img.shields.io/codecov/c/github/coderanger/rspec-param.svg)](https://codecov.io/github/coderanger/rspec-param)
[![Gemnasium](https://img.shields.io/gemnasium/coderanger/rspec-param.svg)](https://gemnasium.com/coderanger/rspec-param)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

An RSpec helper module for writing parameterized tests with less boilerplate.

## Quick Start

Add the following to your `spec_helper.rb`:

```ruby
RSpec.configure do |config|
  config.include RSpecParam
end
```

and then use it in tests like:

```ruby
define MyThing do
  param(:some_value)
  subject { MyThing.new(some_value) }

  context 'with some_value 1' do
    some_value 1
    it { ... }
  end

  context 'with some_value 2' do
    some_value 2
    it { ... }
  end
end
```

## Using Params

Example params are super-charged `let()` variables. Declaring a param works like
a `let`, either using a block to set the default value, or a normal value:

```ruby
define MyThing do
  param(:with_a_block) { 'some default' }
  param(:with_a_value, 42)
end
```

Once set up, a param can be set in any nested context using a shorter syntax
as compared to normal `let` variables:

```ruby
define MyThing do
  param(:some_value)
  context 'with a block' do
    some_value { 1 }
  end
  context 'with a value' do
    some_value 1
  end
end
```

Anywhere inside an example or RPpec helper that you would use a `let` variable,
you can use a param instead.

## Accumulators

As a special mode, you can tell a param to accumulate all values from each
context rather than overriding the value:

```ruby
define MyThing do
  param(:some_value)
  context 'inner' do
    some_value 1
    it { expect(some_value).to eq [1] }
    context 'more inner' do
      some_value { 2 }
      it { expect(some_value).to eq [1, 2] }
    end
  end
end
```

## License

Copyright 2016, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
