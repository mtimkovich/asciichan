require "sinatra"
require_relative "models"

$CACHE = {}

def get_art(update = false)
  key = "top"

  if not $CACHE.has_key?(key) or update
    logger.info("DB QUERY")
    art = Art.all(order: [:id.desc], limit: 10)
    $CACHE[key] = art
  end

  $CACHE[key]
end

get "/" do
  @art = get_art
  erb :index
end

post "/" do
  a = Art::create(
    title:       params[:title],
    art:         params[:art],
    created_at:  Time.now
  )

  if a.save
    get_art(true)
    redirect "/"
  else
    @error = "submission must have both title and art"
    @art = get_art

    erb :index
  end
end
