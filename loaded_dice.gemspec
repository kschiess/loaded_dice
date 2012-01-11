# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'loaded_dice'
  s.version = '0.1.0'

  s.authors = ['Kaspar Schiess']
  s.date = Date.today
  s.email = 'kaspar.schiess@absurd.li'
  s.extra_rdoc_files = ['README']
  s.files = %w(LICENSE README) + Dir.glob("{lib}/**/*")
  s.homepage = 'http://kschiess.github.com/loaded_dice'
  s.rdoc_options = ['--main', 'README']
  s.require_paths = ['lib']
  s.summary = 'Simulates a loaded die with n sides. Perfect for non homogenous randomisation needs.'  
end
