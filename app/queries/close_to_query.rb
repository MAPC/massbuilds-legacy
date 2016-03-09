class CloseToQuery

  def initialize(relation)
    @relation = relation
  end

  def scope
    proc do |latitude, longitude, distance_in_meters = 2000|
      @relation.where(%{
        ST_DWithin(
          ST_GeographyFromText(
            'SRID=4326;POINT(' || developments.longitude || ' ' || developments.latitude || ')'
          ),
          ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
          %d
        )
      } % [longitude, latitude, distance_in_meters])
    end
  end

end
