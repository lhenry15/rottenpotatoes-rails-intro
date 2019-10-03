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
    # get sort_field
    @all_ratings = Movie.get_ratings
    if Movie.column_names.include?(params[:sort])
      session[:sort] = params[:sort]
      @sort_field = session[:sort]
    else
      if !session[:sort].nil?
        @sort_field = session[:sort]
      else
        @sort_field = nil
      end
    end

    # get ratings parameters
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      # This check is to ensure it is a hash
      if session[:ratings].respond_to?(:keys)
        @checked_ratings = session[:ratings].keys
      else
        @checked_ratings = session[:ratings]
      end
    else
      if !session[:ratings].nil?
        if !session[:sort].nil?
          # Redirects for restfulness
          flash.keep
          redirect_to sort: session[:sort], ratings: session[:ratings]
        else
          flash.keep
          redirect_to ratings: session[:ratings]
        end
        # This check is to ensure it is a hash
        if session[:ratings].respond_to?(:keys)
          @checked_ratings = session[:ratings].keys
        else
          @checked_ratings = session[:ratings]
        end
      else
        if !session[:sort].nil?
          flash.keep
          redirect_to sort: session[:sort], ratings: session[:ratings]
        else
          flash.keep
          redirect_to ratings: @all_ratings
        end
        @checked_ratings = @all_ratings
      end
    end

    # sorting on the query for rating
    if !@sort_field.nil?
      @movies = Movie.order(@sort_field).where(rating: @checked_ratings)
    else
      @movies = Movie.where(rating: @checked_ratings)
    end
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
