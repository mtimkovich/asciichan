def get_gmaps_img(points)
  gmaps_url = 'http://maps.googleapis.com/maps/api/staticmap?size=380x263&sensor=false&'

  return gmaps_url + points.map { |p| "markers=#{p}" }.join('&')
end

def get_coords(ip)
  ip_url = 'http://api.hostip.info/get_json.php?position=true&ip='

  url = ip_url + ip

  begin
    content = Net::HTTP.get URI.parse(url)
  rescue SocketError
    return
  end

  if not content.nil?
    j = JSON.parse(content)

    lat = j['lat']
    lng = j['lng']

    if not lat.nil? and not lng.nil?
      return "#{lat},#{lng}"
    else
      return
    end
  end
end
