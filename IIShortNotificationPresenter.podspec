Pod::Spec.new do |s|
  s.name      = 'IIShortNotificationPresenter'
  s.version   = '1.0'
  s.summary   = 'Presents short notifications over a view. Supports queuing and 3 presentation styles.'
  s.homepage  = 'https://github.com/Inferis/IIShortNotificationPresenter'
  s.license   = { :type => 'MIT', :file => 'LICENSE' }
  s.author    = { 'Tom Adriaenssen' =>  'http://inferis.org/' }             
  s.source    = { :git => 'https://github.com/Inferis/IIShortNotificationPresenter.git',
                  :tag => '1.0'}
  s.source_files  = 'IIShortNotificationPresenter/*.{h,m}'
  s.requires_arc  = true
end
