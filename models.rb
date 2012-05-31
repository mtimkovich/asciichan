require "data_mapper"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/art.db")

class Art
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String,    required:   true
  property :art,          Text,      required:   true
  property :created_at,   DateTime,  required:   true
end

DataMapper.finalize

Art.auto_upgrade!

