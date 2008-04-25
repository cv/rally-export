require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = { :session_key => "_rally_export_session", :secret => "rally export tool rally export tool rally export tool" }
end

# edit this to point at the location where the Stories.xml file gets downloaded to
ExportConfig::stories_xml_location = "/Users/cv/Downloads/Stories.xml"