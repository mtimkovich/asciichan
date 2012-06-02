def get_coords(ip)
  ip = '8.8.8.8'
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
