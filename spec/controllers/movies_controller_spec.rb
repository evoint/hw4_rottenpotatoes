require 'spec_helper'

describe MoviesController do
	describe 'show list of all movies with all ratings, and filtered by ratings and/or sorted alphabetically or by release date' do
		before :each do
			@m1 = mock(Movie, :title => 'Aladdin', :rating => 'G', :release_date => '25-Nov-1992', :id => '1')			
			@m3 = mock(Movie, :title => 'Raiders of the Lost Ark ', :rating => 'PG', :release_date => '12-Jun-1981', :id => '9')						
			@m6 = mock(Movie, :title => 'The Incredibles', :rating => 'PG', :release_date => '5-Nov-2004', :id => '8')
			@m7 = mock(Movie, :title => 'Chicken Run', :rating => 'G', :release_date => '21-Jun-2000', :id => '10')			
			@fake_movies = [@m1, @m3, @m6, @m7]
			@fake_all_ratings = %w(G PG PG-13 NC-17 R)
			@fake_selected_ratings = {'G' => '1', 'PG' => '1'}
			Movie.stub(:all_ratings).and_return(@fake_all_ratings)			
		end
  		it 'should follow a route and call a method to show returned movies' do
  			get :index  			
  		end
  		it 'should call the model method that gets all ratings' do
  			Movie.should_receive(:all_ratings).and_return(@fake_all_ratings)
    		get :index, {:ratings => @fake_all_ratings}
  		end
  		it 'should call the model method that finds all movies by selected ratings' do
  			session[:ratings] = @fake_selected_ratings
  			Movie.should_receive(:find_all_by_rating).with(@fake_selected_ratings.keys, nil).and_return(@fake_movies)
    		get :index, {:ratings => @fake_selected_ratings}
  		end
  		it 'should call the model method that finds all movies by selected ratings ordered by title' do
  			session[:ratings] = @fake_selected_ratings
  			session[:sort] = 'title'
  			Movie.should_receive(:find_all_by_rating).with(@fake_selected_ratings.keys, {:order => :title}).and_return(@fake_movies)
    		get :index, {:sort => 'title', :ratings => @fake_selected_ratings}
  		end
  		it 'should call the model method that finds all movies by selected ratings ordered by release date' do
  			session[:ratings] = @fake_selected_ratings
  			session[:sort] = 'release_date'  			
  			Movie.should_receive(:find_all_by_rating).with(@fake_selected_ratings.keys, {:order => :release_date}).and_return(@fake_movies)
    		get :index, {:sort => 'release_date', :ratings => @fake_selected_ratings}
  		end 
  		it 'should redirect if the sort order criteria has changed to title' do
  			session[:sort] = 'release_date'
  			get :index, {:sort => 'title', :ratings => @fake_selected_ratings}
  			response.should redirect_to(movies_path(:sort => 'title', :ratings => @fake_selected_ratings))
  		end
  		it 'should redirect if the sort order criteria has changed to release date' do
  			session[:sort] = 'title'
  			get :index, {:sort => 'release_date', :ratings => @fake_selected_ratings}
  			response.should redirect_to(movies_path(:sort => 'release_date', :ratings => @fake_selected_ratings))
  		end
  		it 'should redirect if the selected ratings have changed' do
  			session[:ratings] = @fake_all_ratings
  			get :index, {:sort => 'title', :ratings => @fake_selected_ratings}
  			response.should redirect_to(movies_path(:sort => 'title', :ratings => @fake_selected_ratings))
  		end
  	end

	describe 'adds a director to an existing movie' do
		before :each do
			@m = mock(Movie, :title => 'Alien', :director => nil, :id => '3')			
			@m_new = ['title' => 'Alien', 'director' => 'Ridley Scott', 'id' => '3']			
			Movie.stub(:find).with('3').and_return(@m)
			@m.stub(:update_attributes!).with(@m_new).and_return(true)
		end
		it 'should load the edit page with the movie details' do
			Movie.should_receive(:find).with('3').and_return(@m)
			get :edit, {:id => '3'}
		end
		it 'should find the movie to update' do
			Movie.should_receive(:find).with('3').and_return(@m)
			put :update, {:id => '3', :movie => @m_new}
		end

		it 'should call the model method that updates the movie' do
			@m.should_receive(:update_attributes!).with(@m_new).and_return(true)
			put :update, {:id => '3', :movie => @m_new}
		end
		it 'should generate a flash notice that the movie was updated' do
			put :update, {:id => '3', :movie => @m_new}
			flash[:notice].should_not be_nil
		end
		it 'should redirect to the movie details page' do
			put :update, {:id => '3', :movie => @m_new}
			response.should redirect_to(movie_path(@m))
		end
		it 'should show the updated Movie' do
			Movie.should_receive(:find).with('3').and_return(@m_new)
			get :show, {:id => '3'}
		end
	end	

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
			Movie.should_receive(:similar_movies).with('1').and_return(@fake_results)
			post :similar, {:movie_id => '1'}
		end
		#for model: it 'should find the director of the movie'
		#for model: it 'should find movies by the same director'
		it 'should check if any movies are returned' do
			post :similar, {:movie_id => '1'}
			assigns(:movies).should_not == nil
		end
		it 'should return a view and show similar movies by the director' do
			post :similar, {:movie_id => '1'}
			response.should render_template('similar')
			assigns(:movies).should == @fake_results
		end
	end

	describe 'searching for movies by director but no director exists' do
		before :each do
			@m1 = mock(Movie, :title => 'Star Wars', :director => nil, :id => '1')
			@fake_results = nil
			Movie.stub(:similar_movies).with('1').and_return(@fake_results)
			Movie.stub(:find).with('1').and_return(@m1)
		end		
		it 'should follow a route and call a method for find similar movies' do
			post :similar, {:movie_id => '1'}
		end
		it 'should call the model method that finds similar movies' do
			Movie.should_receive(:similar_movies).with('1').and_return(@fake_results)
			post :similar, {:movie_id => '1'}
		end
		#for model: it 'should NOT find the director of the movie'
		it 'should check if any movies returned' do
			post :similar, {:movie_id => '1'}
			assigns(:movies).should == @fake_results
		end
		it 'should generate a flash notice that the movie has no director info' do
			Movie.should_receive(:find).with('1').and_return(@m1)
			post :similar, {:movie_id => '1'}
			flash[:notice].should_not be_nil
		end
		it 'should redirect to the index template' do
			post :similar, {:movie_id => '1'}
			response.should redirect_to(movies_path)
		end
	end

	describe 'creating a new movie' do
		before :each do
			@m1 = mock(Movie, :title => 'Alien', :rating => 'G', :director => 'Ridley Scott', :release_date => '25-Nov-1992', :id => '3')
			@m_new = ['title' => 'Alien', 'rating' => 'G', 'director' => 'Ridley Scott', 'release_date' => '25-Nov-1992']
			Movie.stub(:create!).with(@m_new).and_return(@m1)					
		end
		it 'should follow a route and call a method to create a movie' do
			post :create, {:movie => @m_new}
		end
		it 'should call the model method that creates a movie' do
			Movie.should_receive(:create!).with(@m_new).and_return(@m1)
			post :create, {:movie => @m_new}
		end
		it 'should generate a flash notice that the movie was created' do
			post :create, {:movie => @m_new}
			flash[:notice].should_not be_nil
		end
		it 'should redirect to the index template' do
			post :create, {:movie => @m_new}
			response.should redirect_to(movies_path)
		end
	end

	describe 'deleting a movie' do
		before :each do
			@m1 = mock(Movie, :title => 'Alien', :rating => 'G', :director => 'Ridley Scott', :release_date => '25-Nov-1992', :id => '3')
			#@m_new = ['title' => 'Alien', 'rating' => 'G', 'director' => 'Ridley Scott', 'release_date' => '25-Nov-1992']
			Movie.stub(:find).with('3').and_return(@m1)
			@m1.stub(:destroy)
		end
		it 'should follow a route and call a method to delete a movie' do
			delete :destroy, {:id => '3'}
		end
		it 'should call the model method that deletes a movie' do
			@m1.should_receive(:destroy)
			delete :destroy, {:id => '3'}
		end
		it 'should generate a flash notice that the movie was created' do
			delete :destroy, {:id => '3'}
			flash[:notice].should_not be_nil
		end
		it 'should redirect to the index template' do
			delete :destroy, {:id => '3'}
			response.should redirect_to(movies_path)
		end
	end
end