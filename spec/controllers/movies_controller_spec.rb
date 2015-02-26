require 'spec_helper'

describe MoviesController do

  def valid_attributes
    {:rating =>'G', :director =>'Clint Eastwood'}
  end


  describe 'add director' do
    before :each do
      @m=mock(Movie, :title => 'Star Wars', :director => 'director', :id => '1')
      Movie.stub!(:find).with('1').and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      @m.stub!(:update_attributes!).and_return(true)
      put :update, {:id => '1', :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end

  describe 'happy path' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end

    it 'should generate routing for Similar Movies' do
      { :post => movie_same_director_path(1) }.should route_to(:controller => "movies", :action => "same_director", :movie_id => "1")
    end
    it 'should call the model method that finds similar movies' do
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:under_same_director).with('director').and_return(fake_results)
      get :same_director, :movie_id => "1"
    end
    it 'should select the Similar template for rendering and make results available' do
      Movie.stub!(:under_same_director).with('director').and_return(@m)
      get :same_director, :movie_id => "1"
      response.should render_template('same_director')
      assigns(:same).should == @m
    end
  end

  describe 'sad path' do
    before :each do
      m=mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub!(:find).with("1").and_return(m)
    end

    it 'should generate routing for Similar Movies' do
      { :post => movie_same_director_path(1) }.
          should route_to(:controller => "movies", :action => "same_director", :movie_id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :same_director, :movie_id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

  describe 'create and destroy' do
    it 'should create a new movie' do
      MoviesController.stub(:create).and_return(mock('Movie'))
      post :create, {:id => "1"}
    end
    it 'should destroy a movie' do
      m = mock(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub!(:find).with("10").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "10"}
    end
  end


  describe "GET index" do
    context "with RESTful URL" do
      it "assigns all movies as @movies" do
        movie = Movie.create! valid_attributes
        session[:sort] = "title"
        session[:ratings] = {"G"=>"1"}
        get :index, :sort =>session[:sort], :ratings=> session[:ratings]
        assigns(:movies).should eq([movie])
      end
    end

    context "without RESTful URL" do
      it "is missing the sort parameter" do
        session[:sort] = "title"
        session[:ratings] = {"G"=>"1"}
        get :index
        response.should redirect_to(movies_path(:ratings=>session[:ratings]))
      end
      it "is missing the ratings parameter" do
        session[:sort] = "release_date"
        session[:ratings] = {"G"=>"1"}
        get :index, :sort => session[:sort]
        response.should redirect_to(movies_path(:ratings=>session[:ratings]))
      end
    end
  end

  describe "GET show" do
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :show, :id => movie.id
      assigns(:movie).should eq(movie)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new movie" do
        expect {
          post :create, :movie => valid_attributes
        }.to change(Movie, :count).by(1)
      end

      it "assigns a newly created movie as @movie" do
        post :create, :movie => valid_attributes
        assigns(:movie).should be_a(Movie)
        assigns(:movie).should be_persisted
      end

      it "redirects to the homepage" do
        post :create, :movie => valid_attributes
        response.should redirect_to(movies_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested movie" do
        movie = Movie.create! valid_attributes
        # Assuming there are no other movies in the database, this
        # specifies that the movie created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Movie.any_instance.should_receive(:update_attributes!).with({'title' => 'params'})
        put :update, :id => movie.id, :movie => {'title' => 'params'}
      end

      it "assigns the requested movie as @movie" do
        movie = Movie.create! valid_attributes
        put :update, :id => movie.id, :movie => valid_attributes
        assigns(:movie).should eq(movie)
      end

      it "redirects to the homepage" do
        movie = Movie.create! valid_attributes
        put :update, :id => movie.id, :movie => valid_attributes
        response.should redirect_to(movie_path(movie))
      end
    end
  end

end
