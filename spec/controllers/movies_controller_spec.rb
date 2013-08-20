require 'spec_helper'

describe MoviesController do
	describe 'adds a director to an existing movie'
		it 'should receive the directors name'
		it 'should find the movie to update'
		it 'should call the model method that updates the movie'
		it 'should redirect to the movie details page'

	describe 'searching for movies by director' do
		before :each do
			@m1 = mock(Movie, :title => 'Star Wars', :director => 'George Lucas', :id => '1')			
			@m2 = mock(Movie, :title => 'THX-1138', :director => 'George Lucas', :id => '4')			
			@fake_results = [@m1, @m2]
			Movie.stub(:similar_movies).with('1').and_return(@fake_results)
		end

		it 'should follow a route and call a method for find similar movies' do
			post :similar, {:movie_id => '1'}
		end
		it 'should call the model method that finds similar movies' do
			#fake_results = [mock('Movie'), mock('Movie')]
			Movie.should_receive(:similar_movies).with('1').and_return(@fake_results)
			post :similar, {:movie_id => '1'}
		end
		#for model: it 'should find the director of the movie'
		#for model: it 'should find movies by the same director'
		it 'should return a view and show similar movies by the director' do
			#fake_results = [mock('Movie'), mock('Movie')]
			#Movie.stub(:similar_movies).with('1').and_return(fake_results)
			post :similar, {:movie_id => '1'}
			response.should render_template('similar')
			assigns(:movies).should == @fake_results
		end
	end

	describe 'searching for movies by director but no director exists'	
		it 'should follow a route and call a method for find similar movies'
		it 'should call the model method that finds similar movies'
		#for model: it 'should NOT find the director of the movie'
		it 'should generate a flash notice that the movie has no director info'
		it 'should redirect to the index template'
end