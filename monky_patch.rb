# -*- coding: utf-8 -*-

class Gtk::MikutterWindow
  alias :initialize_org :initialize

  def initialize(imaginally, *args)
    initialize_org(imaginally, *args)
    self.decorated = false
  end

end

module Plugin::Gtk::ToolbarGenerator 
  class << self
    alias_method :generate_org, :generate
  end

  def self.generate(container, event, role)
    Thread.new{
      Plugin.filtering(:command, {}).first.values.select{ |command|
        command[:icon] and command[:role] == role and command[:condition] === event }
    }.next{ |commands|
      commands.each{ |command|
        face = command[:show_face] || command[:name] || command[:slug].to_s
        name = if defined? face.call then lambda{ |x| face.call(event) } else face end
        toolitem = ::Gtk::Button.new

        icon = nil

        if command[:icon].is_a?(Proc)
          icon = command[:icon].call(*[nil, container][0, (command[:icon].arity == -1 ? 1 : command[:icon].arity)])
        else
          icon = command[:icon]
        end

        toolitem.add(::Gtk::WebIcon.new(icon, 16, 16))
        toolitem.tooltip(name)
        toolitem.relief = ::Gtk::RELIEF_NONE
        toolitem.ssc(:clicked){
          command[:exec].call(event) }
        container.closeup(toolitem) 

        Plugin.call(:add_toolitem, { :toolitem => toolitem, :command => command })
      }

      container.ssc(:realize, &:queue_resize)
        container.show_all if not commands.empty?
    }.trap{ |e|
      error "error on command toolbar:"
      error e
    }.terminate
    container end
end


