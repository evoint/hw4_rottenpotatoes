require 'spec_helper'

describe Movie do
  describe 'searching for similar movies with same director' do
  	context 'director exists' do
  		it 'should call db with movie id and find movies by the same director' do
        m1 = mock(Movie, :title => 'Star Wars', :director => 'George Lucas', :id => '1')     
        m2 = mock(Movie, :title => 'THX-1138', :director => 'George Lucas', :id => '4')
        fake_results = [m1, m2]
        Movie.should_receive(:find).with('1').and_return(m1)
        Movie.should_receive(:find_all_by_director).with('George Lucas').and_return(fake_results)
  			#Movie.director.should_not be_empty
  			Movie.similar_movies('1')
  		end 		
	  end
    context 'no director exists' do
		  it 'should NOT find the director of the movie'
    end
  end	
end