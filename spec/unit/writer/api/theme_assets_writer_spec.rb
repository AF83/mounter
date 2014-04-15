require 'spec_helper'

require 'locomotive/mounter/writer/api/base'
require 'locomotive/mounter/writer/api/theme_assets_writer'

describe Locomotive::Mounter::Writer::Api::ThemeAssetsWriter do

  let(:writer) { build_theme_asset_writer }

  describe '#theme_asset_changed?' do

    let(:theme_asset) { build_theme_asset(filepath: filepath, folder: folder) }

    context 'an image' do

      let(:filepath) { full_asset_path('images/nav_on.png') }
      let(:folder) { 'images' }

      it 'returns false if same file' do
        writer.checksums[theme_asset._id] = 'edb293028f9c07f2d692d066cd8a458a'
        writer.send(:theme_asset_changed?, theme_asset).should be_false
      end

      it 'returns true if different file' do
        writer.checksums[theme_asset._id] = 42
        writer.send(:theme_asset_changed?, theme_asset).should be_true
      end

    end

    context 'a non compiled javascript file' do

      let(:filepath) { full_asset_path('javascripts/common.js') }
      let(:folder) { 'javascripts' }

      it 'returns false if same file' do
        writer.checksums[theme_asset._id] = 'd022b03c74a7b7386072c775861b39e4'
        writer.send(:theme_asset_changed?, theme_asset).should be_false
      end

      it 'returns true if different file' do
        writer.checksums[theme_asset._id] = 42
        writer.send(:theme_asset_changed?, theme_asset).should be_true
      end

    end

    context 'a compiled javascript file' do

      let(:filepath) { full_asset_path('javascripts/application.js.coffee') }
      let(:folder) { 'javascripts' }

      it 'returns false if same file' do
        writer.checksums[theme_asset._id] = 'c9c70afc24b19736b0969182f2d04dd3'
        writer.send(:theme_asset_changed?, theme_asset).should be_false
      end

      it 'returns true if different file' do
        writer.checksums[theme_asset._id] = 42
        writer.send(:theme_asset_changed?, theme_asset).should be_true
      end

    end

    context 'a stylesheet file' do

      let(:filepath) { full_asset_path('stylesheets/application.css') }
      let(:folder) { 'stylesheets' }

      it 'returns false if same file' do
        writer.checksums[theme_asset._id] = 'b471ce408b8dc334187d09dfa99d49d2'
        writer.send(:theme_asset_changed?, theme_asset).should be_false
      end

      it 'returns true if different file' do
        writer.checksums[theme_asset._id] = 42
        writer.send(:theme_asset_changed?, theme_asset).should be_true
      end

    end

  end

  def build_theme_asset_writer
    Locomotive::Mounter::Writer::Api::ThemeAssetsWriter.new(nil, nil).tap do |writer|
      writer.remote_base_url = 'http://cdn.locomotivehosting.com/sites/4c2330706f40d50ae2000005/theme'
      writer.checksums = {}
      writer.cached_compiled_assets = {}
      writer.stub(sprockets: sprockets)
    end
  end

  def build_theme_asset(attributes = {})
    filepath = attributes.delete(:filepath)
    Locomotive::Mounter::Models::ThemeAsset.new(attributes).tap do |asset|
      asset.filepath = filepath
    end
  end

  def site_path
    File.expand_path '../../../../fixtures/default', __FILE__
  end

  def full_asset_path(asset_path)
    File.join(site_path, 'public', asset_path)
  end

  def sprockets
    Locomotive::Mounter::Extensions::Sprockets.environment(site_path)
  end

end