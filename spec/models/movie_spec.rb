require 'spec_helper'

describe Movie do
  describe 'searching for similar movies with same director' do
  	context 'director exists' do
  		it 'should call db with movie id and find movies by the same director' do
        m1 = mock(Movie, :title => 'Star Wars', :director => 'George Lucas', :id => '1')     
        m2 = mock(Movie, :title => 'THX-1138', :director => 'George Lucas', :id => '4')
        fake_results = [m1, m2]
        Movie.should_receive(:find).with('1').and_return(m1)
        Movie.should_receive(:find_all_by_director).with(m1.director).and_return(fake_results)
  			Movie.similar_movies('1').should == fake_results
  		end 		
	  end
    context 'no director exists' do
		  it 'should NOT find the director of the movie' do
        m1 = mock(Movie, :title => 'Star Wars', :director => nil, :id => '1')     
        m2 = mock(Movie, :title => 'THX-1138', :director => nil, :id => '4')
        fake_results = [m1, m2]
        Movie.should_receive(:find).with('1').and_return(m1)
        Movie.stub(:find_all_by_director).with(m1.director).and_return(fake_results)
        Movie.similar_movies('1').should == nil        
      end
    end
  end	
end