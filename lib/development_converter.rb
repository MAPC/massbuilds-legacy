require 'ostruct'
require 'geocoder'

class DevelopmentConverter

  SQ_FT_PER_ACRE = 43560

  def initialize(attributes)
    @old = OpenStruct.new attributes.to_h
  end

  def to_h
    # If the attribute value is a symbol, call that method on the old development.
    # Otherwise, if the attribute is a method, just let the method be called.
    Hash[
      attribute_converters.map do |k, attribute|
        if attribute.is_a? Symbol
          [k, @old.send(attribute)]
        else
          [k, attribute]
        end
      end
    ]
  end

  def attribute_converters
    {
      fa_ret:    floor_area_from_percents(:retpct),
      fa_ofcmd:  floor_area_from_percents(:ofcmdpct),
      fa_indmf:  floor_area_from_percents(:indmfpct),
      fa_whs:    floor_area_from_percents(:whspct),
      fa_rnd:    floor_area_from_percents(:rndpct),
      fa_edinst: floor_area_from_percents(:edinstpct),
      fa_other:  floor_area_from_percents(:othpct),
      latitude:              latitude,
      longitude:             longitude,
      street_view_latitude:  latitude,
      street_view_longitude: longitude,
      total_cost:  :total_cost,
      singfamhu:   :singfamhu,
      twnhsmmult:  :twnhsmmult,
      lgmultifam:  :lgmultifam,
      tothu:       :tothu,
      gqpop:       :gqpop,
      commsf:      :commsf,
      rptdemp:     :rptdemp,
      emploss:     :emploss,
      hotelrms:    :hotelrms,
      name:        :ddname,
      description: :description,
      project_url: :url,
      year_compl:  :complyr,
      mixed_use:   :mxduse,
      rdv:         :rdv,
      asofright:   :as_of_right,
      ovr55:       :ovr55,
      clusteros:   :clustosrd,
      phased:      :phased,
      stalled:     :stalled,
      :private =>  :draft,
      onsitepark: :parking_spaces,
      other_rate: :otheremprat2,
      created_at: :created,
      updated_at: :last_modified,
      affordable: :affordable,
      address:     address,
      state:       state,
      zip_code:    zip_code,
      tagline:     :projecttype_detail,
      status:      status,
      creator:     User.first
    }
  end

  def latitude
    location.last
  end

  def longitude
    location.first
  end

  def location
    @old.location.delete('POINT(').delete(')').split(' ').map(&:to_f)
  end

  # TODO: What needs to occur before this step?
  def relationships
    {
      programs: [
        Program.where(name: zoning_tool)
      ],
      walkscore: walkscore,
      creator:   creator,
      development_team_memberships: []
    }
  end

  def creator
    User.find @old.last_modified_by_id
  end

  def walkscore
    {
      status:         @old.walkscore_status,
      walkscore:      @old.walkscore_walkscore,
      description:    @old.walkscore_description,
      updated:        @old.walkscore_updated,
      logo_url:       "https://cdn.walk.sc/images/api-logo.png",
      more_info_icon: "https://cdn.walk.sc/images/api-more-info.gif",
      more_info_link: "https://www.redfin.com/how-walk-score-works",
      ws_link:        "https://www.walkscore.com/score/loc/lat=#{latitude}/lng=#{longitude}/?utm_source=mapc.org&utm_medium=ws_api&utm_campaign=ws_api",
      help_link:      "https://www.redfin.com/how-walk-score-works",
      snapped_lat:    @old.walkscore_snapped_lat,
      snapped_lon:    @old.walkscore_snapped_lon
    }
  end

  def status
    return 'in_construction' if @old.status == "Construction"
    @old.status.downcase
  end

  def address
    if @old.ddname.match(/^(\d+)/)
      @old.ddname
    else
      geo['formatted_address'].partition(',').first.strip
    end
  end

  def geo
    @geo ||= Geocoder.search("#{latitude},#{longitude}").first.data
  end

  def state
    'MA'
  end

  def zip_code
    component = geo['address_components'].select do |comp|
      comp['types'].include?('postal_code')
    end.first
    if component
      component['short_name']
    else
      nil
    end
  end

  def prjarea
    @old.prjacrs * SQ_FT_PER_ACRE
  end

  def affordable
    # TODO: This attribute.
    raise NotImplementedError
  end

  private

  def floor_area_from_percents(attribute)
    (@old.send(attribute).to_i / 100) * @old.commsf.to_i
  rescue ZeroDivisionError
    0
  end

end
