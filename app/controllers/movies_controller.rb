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
#    session.clear
    @all_ratings = Movie.select('DISTINCT rating').order('rating ASC').collect {|result| result.rating}#Movie.ratings
#    @movies = Movie.order(params[:sort_by])#Movie.all
 
    filters = {:sort_by => "", :ratings => {"G" => "1", "R" => "1", "PG" => "1", "PG-13" => "1", "NC-17" => "1"}}
    redirect = false
    filters.each do |filter, default|
      if params[filter].blank?
        if !session[filter].blank?
          redirect = true
          params[filter] = session[filter]
        else
          params[filter] = default
        end
      end
      session[filter] = params[filter]
    end
#    puts '1' + session[:sort_by].to_s
#    puts '2' + session[:ratings].keys.to_s
    redirect_to movies_path(:sort_by => params[:sort_by], :ratings => params[:ratings]) if redirect
    condition = params[:ratings].keys
    order = params[:sort_by]
#    puts '3' + condition.to_s
#    puts '4' + order.to_s
    @movies = Movie.where("rating": condition).order(params[:sort_by])
#    @movies = Movie.order(params[:sort_by])
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
