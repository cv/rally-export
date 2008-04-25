
module ExportConfig
  
  def self.stories_xml_location=(location)
    @@stories_xml_location = location
  end
  
  def self.stories_xml_location
    @@stories_xml_location
  end
  
end