require 'hpricot'
require 'morph'

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
    story
  end
  
  def to_s
    "#{formatted_id}: #{name} (pri #{priority}, est #{estimate}, it #{iteration})"    
  end
  
end

Filter = Struct.new :query, :order

class ExportController < ApplicationController

  def index
    # f = Filter.new params[:filter][:query], params[:filter][:order]
    # h = Hpricot::XML from_rally(f.query, f.order)
    h = Hpricot::XML open('/Users/cv/Downloads/Stories.xml')
    @stories = (h/'HierarchicalRequirement').collect {|e| Story.from(e) }
  end
  
  private
    
  def from_rally(query=nil, order=nil)
    `lib/rally-downloader.sh '#{query}' '#{order}'`
  end
  
end
