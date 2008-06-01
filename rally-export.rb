require 'hpricot'
require 'morph'

Merb::Router.prepare do |r|
  r.match('/').to(:controller => 'exporter', :action =>'index')
end

Merb::Config.use { |c|
  c[:framework]           = {},
  c[:session_store]       = 'none',
  c[:exception_details]   = true
}

class Exporter < Merb::Controller
  def index
    h = Hpricot::XML open('/Users/administrator/Downloads/Stories.xml')
    @stories = (h/'HierarchicalRequirement').collect {|e| Story.from(e) }
    render :template=>'../../index'
  end
end

class Story
  include Morph
  
  def self.from(e)    
    story = new    
    story.formatted_id = (e/'FormattedID').inner_text
    story.name = (e/'Name').inner_text
    story.estimate = (e/'PlanEstimate').inner_text.to_i
    story.iteration = (e/'Iteration').first ? (e/'Iteration').first.attributes['refObjectName'].strip.to_i : 'BACKLOG'
    story.priority = (e/'Rank').inner_text.to_f
    story.description = (e/'Description').inner_text
    story.release = (e/'Release').first ? (e/'Release').first.attributes['refObjectName'].strip : 'UNSCHEDULED'
    story
  end
  
  def to_s
    "#{formatted_id}: #{name} (pri #{priority}, est #{estimate}, it #{iteration})"    
  end
  
end