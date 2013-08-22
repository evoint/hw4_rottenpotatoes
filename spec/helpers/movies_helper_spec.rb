require 'spec_helper'

describe MoviesHelper do
 describe 'returns odd for odd numbers and even for even numbers' do
    it 'should return odd' do
      oddness(7).should == 'odd'
    end
     it 'should return even' do
      oddness(2).should == 'even'
    end
  end

end