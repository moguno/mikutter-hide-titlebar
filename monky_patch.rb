# -*- coding: utf-8 -*-

class Gtk::MikutterWindow
  alias :initialize_org :initialize

  def initialize(imaginally, *args)
    initialize_org(imaginally, *args)
    self.decorated = false
  end

end
