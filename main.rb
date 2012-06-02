require 'sinatra'
require 'net/http'
require 'json'

require_relative 'models'

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

def get_coords(ip)
  ip = '12.215.42.19'
  ip_url = 'http://api.hostip.info/get_json.php?position=true&ip='

  url = ip_url + ip

  begin
    content = Net::HTTP.get URI.parse(url)
  rescue SocketError
    return
  end

  if content
    j = JSON.parse(content)

    lat = j['lat']
    lng = j['lng']

    return "#{lat},#{lng}"
  end
end

get '/' do
  @arts = get_art
  erb :index
end

post '/' do
  @title = params[:title]
  @art = params[:art]

  coords = get_coords(request.ip)

  a = Art::create(
    title:       @title,
    art:         @art,
    coords:      coords,
    created_at:  Time.now
  )

  if a.save
    get_art(true)
    redirect '/'
  else
    @error = 'submission must have both title and art'
    @arts = get_art

    erb :index
  end
end
