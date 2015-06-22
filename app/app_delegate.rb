class AppDelegate
  POPUP_WIDTH = 300
  POPUP_HEIGHT = 200
  INNER_HEIGHT = 180
  BUTTON_WIDTH = 40
  BUTTON_HEIGHT = 30

  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    self.buildWindow
    self.buildMenu
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def pressAction
    alert = NSAlert.alloc.init
    alert.setMessageText "Action triggered from status bar menu"
    alert.addButtonWithTitle "OK"
    alert.runModal
  end

  def pressIncrement
    @count ||= 0
    @count += 1

    @status_item.setTitle("#{@count} times")
  end

  def buildWindow
    @window = Motion::Popup::Panel.alloc.initPopup(POPUP_WIDTH, POPUP_HEIGHT)

    @inner_rect = NSInsetRect(@window.contentView.frame, @window.background.line_thickness, @window.background.arrow_height)
    @inner_rect.origin.y += @inner_rect.size.height - INNER_HEIGHT
    @inner_rect.size.height = INNER_HEIGHT

    @inner_box = NSBox.alloc.initWithFrame(@inner_rect)
    @inner_box.setTitle("Popup")
    @window.contentView.addSubview(@inner_box)

    @options_button = NSButton.alloc.initWithFrame(NSMakeRect(POPUP_WIDTH - BUTTON_WIDTH - 5, 5, BUTTON_WIDTH, BUTTON_HEIGHT))
    @options_button.setImagePosition(NSImageOnly)
    @options_button.setBordered(false)
    @options_button.setTarget(self)
    @options_button.setAction('showMenu:')
    @options_button.setTitle("Menu")
    @window.contentView.addSubview(@options_button)
  end

  def buildMenu
    @status_menu = NSMenu.new

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setTitle(@app_name)
    @status_item.setTarget(@window)
    @status_item.setAction('toggle')

    @status_menu.addItem createMenuItem("About #{@app_name}", 'orderFrontStandardAboutPanel:')
    @status_menu.addItem createMenuItem("Custom Action", 'pressAction')
    @status_menu.addItem createMenuItem("Increment", 'pressIncrement')
    @status_menu.addItem createMenuItem("Quit", 'terminate:')
  end

  def showMenu(sender)
    NSMenu.popUpContextMenu(@status_menu, withEvent: NSApp.currentEvent, forView: sender)
  end
end