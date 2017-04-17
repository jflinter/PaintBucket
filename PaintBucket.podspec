Pod::Spec.new do |s|
  s.name = 'PaintBucket'
  s.version = '0.2'
  s.license = 'MIT'
  s.summary = 'Like a bucket of paint, but on the Internet'
  s.homepage = 'https://github.com/jflinter/PaintBucket'
  s.social_media_url = 'http://twitter.com/jflinter'
  s.author = "Jack Flintermann"
  s.source = { :git => 'https://github.com/jflinter/PaintBucket.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PaintBucket/*.swift'

  s.requires_arc = true
end
