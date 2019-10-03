class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # deal with part 2 assignment
    @all_ratings = Movie.get_ratings
    if !(params[:ratings].nil?)
      check_ratings = params[:ratings]
    else
      check_ratings = Hash[@all_ratings.collect {|item| [item, 1]}]
    end
    @movies = Movie.where(:rating => check_ratings.keys)
    
    
    # deal with part 1 assignment
    if !(params[:sort].nil?)
      @sort_field = params[:sort]
      @movies = @movies.order(@sort_field)
    
    end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
