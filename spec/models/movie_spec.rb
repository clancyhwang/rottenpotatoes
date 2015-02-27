require 'spec_helper'

describe Movie do
  describe 'searching same director movies' do
    it 'should call Movie with director' do
      @m=mock(Movie, :title => 'Star Wars', :director => 'director', :id => '1')
      Movie.should_receive(:under_same_director).with('Star Wars')
      Movie.under_same_director('Star Wars')
    end

  describe '.ratings'
    it 'returns all valid movie ratings' do
      Movie.ratings.should == ['G','PG','PG-13','R','NC-17']
    end
  end
end
