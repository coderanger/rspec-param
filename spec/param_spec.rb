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

require 'spec_helper'

describe RSpecParam do
  context 'with a block default' do
    param(:alpha) { 1 }

    it { expect(alpha).to eq 1 }

    context 'with a block value' do
      alpha { 2 }
      it { expect(alpha).to eq 2 }
    end # /context with a block value

    context 'with a arg value' do
      alpha(2)
      it { expect(alpha).to eq 2 }
    end # /context with a arg value
  end # /context with a block default

  context 'with a value default' do
    param(:alpha, 1)

    it { expect(alpha).to eq 1 }

    context 'with a block value' do
      alpha { 2 }
      it { expect(alpha).to eq 2 }
    end # /context with a block value

    context 'with a arg value' do
      alpha(2)
      it { expect(alpha).to eq 2 }
    end # /context with a arg value
  end # /context with a value default

  context 'with derived default' do
    param(:alpha, 1)
    param(:beta) { alpha + 1 }

    it { expect(beta).to eq 2 }

    context 'with a value' do
      alpha(2)

      it { expect(beta).to eq 3 }
    end # /context with a value
  end # /context with derived default

  context 'with accumulate' do
    param(:alpha, accumulate: true) { [] }

    it { expect(alpha).to eq [] }

    context 'with one block value' do
      alpha { 1 }
      it { expect(alpha).to eq [1] }
    end # /context with one block value

    context 'with one param value' do
      alpha(1)
      it { expect(alpha).to eq [1] }
    end # /context with one param value

    context 'with two nested values' do
      alpha(1)
      context 'inner' do
        alpha(2)
        it { expect(alpha).to eq [1, 2] }
      end
    end # /context with two nested values

    context 'with two flat values' do
      alpha(1)
      alpha(2)
      it { expect(alpha).to eq [1, 2] }
    end # /context with two flat values

    context 'with three flat values' do
      alpha(1)
      alpha(2)
      alpha { 3 }
      it { expect(alpha).to eq [1, 2, 3] }
    end # /context with three flat values

    context 'with a derived value' do
      param(:beta, 1)
      alpha { beta + 2 }
      it { expect(alpha).to eq [3] }
    end # /context with a derived value

    context 'with no default' do
      param(:delta, accumulate: true)
      context 'inner 1' do
        delta 1
        context 'inner 2' do
          delta 2
          it { expect(delta).to eq [1, 2] }
        end
      end
    end # /context with no default
  end # /context with accumulate
end
