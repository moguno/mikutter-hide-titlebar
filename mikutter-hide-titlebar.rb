# -*- coding: utf-8 -*-

require "#{File.dirname(__FILE__)}/monky_patch.rb"

Plugin.create(:hide_titlebar) do
  window = nil

  command(:move_window,
          name: 'ウインドウ移動',
          condition: lambda{ |opt| true },
          visible: true,
          icon: "#{File.dirname(__FILE__)}/application.png",
          role: :window) do |opt| end

  on_add_toolitem { |opt|
    # ウインドウ移動ボタン押下 -> ウインドウ移動開始
    if opt[:command][:slug] == :move_window
      opt[:toolitem].ssc(:button_press_event) { |w, e|
        window.begin_move_drag(e.button, e.x_root, e.y_root, e.time)
      }
    end
  }

  command(:close_window,
          name: 'ウインドウを閉じる',
          condition: lambda{ |opt| true },
          visible: true,
          icon: "#{File.dirname(__FILE__)}/action_delete.png",
          role: :window) do |opt| Gtk.main_quit end

  command(:maximize_window,
          name: 'ウインドウ最大化',
          condition: lambda{ |opt| true },
          visible: true,
          icon: "#{File.dirname(__FILE__)}/action_add.png",
          role: :window) do |opt| 
            if window.window.state.maximized?
              window.unmaximize
            else
              window.maximize 
            end
          end

  command(:minimize_window,
          name: 'ウインドウ最小化',
          condition: lambda{ |opt| true },
          visible: true,
          icon: "#{File.dirname(__FILE__)}/action_remove.png",
          role: :window) do |opt| window.iconify end


  # 起動時処理(for 0.1)
  onboot do |service|
    # メインウインドウを取得
    window_tmp = Plugin.filtering(:get_windows, [])

    if (window_tmp == nil) || (window_tmp[0][0] == nil) then
      next
    end

    window = window_tmp[0][0]
  end


  # 起動時処理(for 0.2)
  on_window_created do |i_window|
    # メインウインドウを取得
    window_tmp = Plugin.filtering(:gui_get_gtk_widget,i_window)

    if (window_tmp == nil) || (window_tmp[0] == nil) then
      next
    end

    window = window_tmp[0]
  end
end
