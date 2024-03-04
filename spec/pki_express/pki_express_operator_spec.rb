require_relative '../spec_helper'

module PkiExpress
  describe PkiExpressOperator do
    it "should remove files created by child classes when GC remove its instance" do
      operator = ChildOperator.new
      temp_files = []
      (1..3).each {
        created_file = operator.create_temp_file
        temp_files.append(created_file)
        expect(File.exist?(created_file)).to equal(true)
      }
      operator = nil
      GC.start

      temp_files.each do |file|
        expect(File.exist?(file)).to equal(false)
      end
    end
  end

  class ChildOperator < PkiExpressOperator
    def initialize(config=PkiExpressConfig.new)
      super(config)
    end

    def create_temp_file
      super
    end
  end
end