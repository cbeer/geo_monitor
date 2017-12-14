require 'spec_helper'

describe GeoMonitor::Layer do
  let(:schema_json) { File.read('spec/fixtures/cz128vq0535.json') }
  subject { described_class.from_geoblacklight(schema_json) }
  describe '.from_geoblacklight' do
    it 'creates an instance with expected fields' do
      expect(subject.checktype).to eq 'WMS'
      expect(subject.slug).to eq 'stanford-cz128vq0535'
      expect(subject.layername).to eq 'druid:cz128vq0535'
      expect(subject.bbox)
        .to eq 'ENVELOPE(29.572742, 35.000308, 4.234077, -1.478794)'
      expect(subject.active).to eq true
      expect(subject.url).to eq 'https://geowebservices.stanford.edu/geoserver/wms'
    end
  end
  describe '#bounding_box' do
    it 'returns an instance of GeoMonitor::BoundingBox' do
      expect(subject.bounding_box).to be_an GeoMonitor::BoundingBox
    end
    it 'parses the CQL Envelope syntax correctly' do
      expect(subject.bounding_box.north).to eq 4.234077
      expect(subject.bounding_box.south).to eq(-1.478794)
      expect(subject.bounding_box.east).to eq 35.000308
      expect(subject.bounding_box.west).to eq 29.572742
    end
  end
  describe '#check' do
    before do
      stub_request(
        :get,
        %r{https:\/\/geowebservices.stanford.edu\/geoserver\/wms}
      ).to_return(status: 200, headers: {})
    end
    it 'creates a GeoMonitor::Status' do
      expect(subject.check).to be_an GeoMonitor::Status
    end
    it 'sends through correct arguments' do
      expect(GeoMonitor::Status).to receive(:from_response).with(
        kind_of(Faraday::Response),
        kind_of(GeoMonitor::Layer),
        kind_of(Float)
      )
      subject.check
    end
  end
end
