require 'sinatra'
require 'logger'
require_relative 'models'


def get_art
  log = Logger.new(STDOUT)

  log.info("DB QUERY")
  Art.all(order: [ :id.desc ], limit: 10)
end

get '/' do
  @art = get_art
  erb :index
end

post '/' do
  a = Art::create(
    title: params[:title],
    art: params[:art],
    created_at: Time.now
  )

  if a.save
    redirect '/'
  else
    @error = "submission must have both title and art"
    @art = get_art

    erb :index
  end
end
