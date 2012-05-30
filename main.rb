require 'sinatra'
require_relative 'models'

get '/' do
  @art = Art.all(order: [ :id.desc ], limit: 10)
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
    @art = Art.all(order: [ :id.desc ], limit: 10)

    erb :index
  end
end
