# coding: utf-8
require_relative 'lib/pki_express/version'

Gem::Specification.new do |spec|
  spec.name = 'pki_express'
  spec.version = PkiExpress::VERSION
  spec.license = 'MIT'
  spec.authors = ['Ismael Medeiros']
  spec.email = %w{ismaelm@lacunasoftware.com}
  spec.homepage = 'http://docs.lacunasoftware.com/en-us/articles/pki-express'
  spec.summary = 'Gem for using PKI Express on Ruby'
  spec.description = 'Classes to use Lacuna Software\'s PKI Express'
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.metadata = {
      'bug_tracker_uri'   => 'https://github.com/LacunaSoftware/PkiExpressRuby/issues',
      'changelog_uri'     => 'https://github.com/LacunaSoftware/PkiExpressRuby/blob/develop/CHANGELOG.md',
      'documentation_uri' => 'http://docs.lacunasoftware.com/en-us/articles/pki-express',
      'source_code_uri'   => 'https://github.com/LacunaSoftware/PkiExpressRuby'
  }

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end