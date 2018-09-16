Pod::Spec.new do |s|
  s.name         = 'HHRefreshManager' 
  s.version      = '1.1.1'
  s.summary      = 'HHRefresh'
  s.description  = 'Mainstream refresh animation'
  s.homepage     = 'https://github.com/yuwind/HHRefreshManager/wiki'
  s.license      = 'MIT'
  s.author       = { '豫风' => '991810133@qq.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/yuwind/HHRefreshManager.git", :tag => s.version}
  s.source_files = 'HHRefreshManager/*.{h,m}'
  s.resource     = 'HHRefreshManager/refreshmImages.bundle'
  s.requires_arc = true

end
