#
# Copyright 2016, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rspec/core/memoized_helpers'


# An RSpec helper module for writing parameterized tests with less boilerplate.
#
# @since 1.0.0
# @example Enable globally
#   RSpec.configure do |config|
#     config.include RSpecCommand
#   end
# @example Enable for a single example group
#   describe 'myapp' do
#     command 'myapp --version'
#     its(:stdout) { it_expected.to include('1.0.0') }
#   end
module RSpecParam
  module ClassMethods
    def param(name, default=nil, accumulate: false, &block)
      raise "One of a default param or block is required" unless default || block || accumulate
      block ||= lambda { accumulate ? (default || []) : default }
      # Create the let variable.
      let(name, &block)
      # Define the helper method.
      define_singleton_method(name) do |value=nil, &inner_block|
        raise "One of a value param or block is required" unless value || inner_block
        let_block = if accumulate
          # Accumulate values into an ivar to handle multiple calls in the
          # same context level.
          ivar = "@param_context_#{name}"
          existing_values = instance_variable_get(ivar) || []
          existing_values << [value, inner_block]
          instance_variable_set(ivar, existing_values)
          lambda do
            super() + existing_values.map {|v, b|  b ? instance_eval(&b) : v }
          end
        else
          inner_block || lambda { value }
        end
        let(name, &let_block)
      end
    end

    def included(klass)
      super
      klass.extend RSpec::Core::MemoizedHelpers::ClassMethods
      klass.include RSpec::Core::MemoizedHelpers
      klass.extend ClassMethods
    end
  end

  extend ClassMethods
end
