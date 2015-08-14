class AppDelegate
  POPUP_WIDTH = 300
  POPUP_HEIGHT = 200
  INNER_HEIGHT = 180
  BUTTON_WIDTH = 40
  BUTTON_HEIGHT = 30
  SCROLL_VIEW_INSET = 3

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

    scroll_view = NSScrollView.alloc.initWithFrame(NSInsetRect(@window.contentView.frame, @window.background.line_thickness + SCROLL_VIEW_INSET, @window.background.arrow_height + SCROLL_VIEW_INSET + (BUTTON_HEIGHT / 2)))
    scroll_view.hasVerticalScroller = true
    @window.contentView.addSubview(scroll_view)

    @collection_view = NSCollectionView.alloc.initWithFrame(
      scroll_view.frame)
    @collection_view.setItemPrototype(VillainPrototype.new)
    @collection_view.setContent(VILLAINS)

    scroll_view.documentView = @collection_view

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