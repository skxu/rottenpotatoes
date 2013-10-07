class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
    @ratings = params[:ratings] || session[:ratings] || {'G' => 1, 'PG' => 1, 'PG-13' => 1, 'R' => 1, 'NC-17' => 1}
    @sort = params[:sort] || session[:sort] || ""
    
    @movies = Movie.find(:all, :order=>@sort, :conditions => ["rating in (?)", @ratings.keys])
	session[:ratings] = @ratings
	session[:sort] = @sort
	
	if params[:sort] != session[:sort]
      redirect_to :sort => @sort, :ratings => @ratings and return
    end

    if params[:ratings] != session[:ratings] and @ratings != nil
		redirect_to :sort => @sort, :ratings => @ratings and return
    end
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
