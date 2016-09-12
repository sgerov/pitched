require 'geoip'

RetrieveLocationJob = Struct.new(:id) do
  def perform
    if pitch = Pitch.find(id)
      if c = GeoIP.new('GeoLiteCity.dat').city(pitch.ip)
        pitch.update(location: c.real_region_name ? (c.real_region_name + ', ' + c.country_name) : c.country_name)
      end
    end
  end
end
