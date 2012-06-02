require 'sinatra'
require 'net/http'
require 'json'

require_relative 'models'
require_relative 'helper'

$CACHE = {}

def get_art(update = false)
  key = 'top'

  if not $CACHE.has_key?(key) or update
    logger.info('DB QUERY')
    art = Art.all(order: [:id.desc], limit: 10)
    $CACHE[key] = art
  end

  $CACHE[key]
end

def render_front
  @arts = get_art

  erb :index
end

get '/' do
  render_front
end

post '/' do
  @title = params[:title]
  @art = params[:art]

  coords = get_coords(request.ip)

  a = Art.new(
    title:       @title,
    art:         @art,
    created_at:  Time.now
  )

  if not coords.nil?
    a.coords = coords
  end

  if a.save
    get_art(true)
    redirect '/'
  else
    @error = 'submission must have both title and art'

    render_front
  end
end
