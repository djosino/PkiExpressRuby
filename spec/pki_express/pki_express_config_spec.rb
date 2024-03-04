require 'faker'

require_relative '../spec_helper'

module PkiExpress
  describe PkiExpressConfig do
    it 'should set valid default values when no value is passed in contructor' do
      config = PkiExpressConfig.new
      expect(config.pki_express_home).to be_nil
      expect(File.directory?(config.temp_folder)).to be(true)
      expect(File.directory?(config.transfer_data_folder)).to be(true)
    end

    it 'should set pki_express_home folder when a valid path is passed' do
      fake_pki_express_home = Dir.mktmpdir('pkie')
      config = PkiExpressConfig.new(fake_pki_express_home)
      expect(config.pki_express_home).to equal(fake_pki_express_home)
      Dir.rmdir(fake_pki_express_home)
    end

    it 'should raise ArgumentError when an invalid path is passed' do
      expect { PkiExpressConfig.new(Faker::String.random) }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when a path is passed but doesn\'t exist' do
      fake_pki_express_home = Faker::File.dir
      expect { PkiExpressConfig.new(fake_pki_express_home) }.to raise_error(ArgumentError)
    end

    it 'should set temp_folder when a valid path is passed' do
      fake_temp_folder = Dir.mktmpdir('pkie')
      config = PkiExpressConfig.new(nil,  fake_temp_folder)
      expect(config.temp_folder).to equal(fake_temp_folder)
      Dir.rmdir(fake_temp_folder)
    end

    it 'should set temp_folder with a default folder when no path is passed' do
      config1 = PkiExpressConfig.new
      config2 = PkiExpressConfig.new
      expect(config1.temp_folder).to equal(config2.temp_folder)
    end

    it 'should raise ArgumentError when an invalid path is passed' do
      expect { PkiExpressConfig.new(nil, Faker::String.random) }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when a path is passed but doesn\'t exist' do
      fake_pki_express_home = Faker::File.dir
      expect { PkiExpressConfig.new(nil, fake_pki_express_home) }.to raise_error(ArgumentError)
    end

    it 'should set transfer_data_folder when a valid path is passed' do
      fake_transfer_data_folder = Dir.mktmpdir('pkie')
      config = PkiExpressConfig.new(nil, nil, fake_transfer_data_folder)
      expect(config.transfer_data_folder).to equal(fake_transfer_data_folder)
      Dir.rmdir(fake_transfer_data_folder)
    end

    it 'should set transfer_data_folder with temp_folder value when no path is passed' do
      config = PkiExpressConfig.new
      expect(config.transfer_data_folder).to equal(config.temp_folder)
    end

    it 'should raise ArgumentError when an invalid path is passed' do
      expect { PkiExpressConfig.new(nil, nil, Faker::String.random) }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError when a path is passed but doesn\'t exist' do
      fake_pki_express_home = Faker::File.dir
      expect { PkiExpressConfig.new(nil, nil, fake_pki_express_home) }.to raise_error(ArgumentError)
    end
  end
end
