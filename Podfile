source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
inhibit_all_warnings!
#use_frameworks!
#
#pre_install do |installer|
#    def installer.verify_no_static_framework_transitive_dependencies; end
#end
#
#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
#            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
#            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
#            config.build_settings['USER_HEADER_SEARCH_PATHS'] = "$(SRCROOT)/**"
#            config.build_settings['ALWAYS_SEARCH_USER_PATHS'] = "YES"
#            if target.name == 'MIHCrypto'
#                config.build_settings['LIBRARY_SEARCH_PATHS'] = "$(SRCROOT)/OpenSSL-Universal/lib-ios/"
#                config.build_settings['OTHER_LDFLAGS'] = "-ObjC -l\"ssl\" -l\"crypto\""
#            end
#        end
#    end
#end

workspace 'SCamera'

project 'SCamera.project'

target :SCamera do
   pod 'Masonry', '~> 1.0.1'
   
   project 'SCamera.project'
end
