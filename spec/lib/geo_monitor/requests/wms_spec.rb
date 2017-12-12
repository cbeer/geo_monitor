require 'spec_helper'

describe GeoMonitor::Requests::WMS do
  let(:url) { 'https://geowebservices.stanford.edu/geoserver/wms' }
  let(:bbox) do
    GeoMonitor::BoundingBox.new(
      north: 4.234077,
      south: -1.478794,
      west: 29.572742,
      east: 35.000308
    )
  end
  let(:layers) { 'druid:cz128vq0535' }
  subject { described_class.new(bbox: bbox, url: url, layers: layers) }

  describe '#tile' do
    it 'requests a wms tile' do
      stub = stub_request(
        :get,
        'https://geowebservices.stanford.edu/geoserver/wms?BBOX=3264742.590082'\
          '5034,0.0,3995282.329624239,625168.6816906171&CRS=EPSG:900913&FORMAT'\
          '=image/png&HEIGHT=256&LAYERS=druid:cz128vq0535&REQUEST=GetMap&SERVI'\
          'CE=WMS&SRS=EPSG:3857&STYLES=&TILED=true&VERSION=1.1.1&WIDTH=256'
      ).to_return(headers: { 'Content-Type' => 'image/png' })
      subject.tile
      expect(stub).to have_been_requested
    end
  end
end