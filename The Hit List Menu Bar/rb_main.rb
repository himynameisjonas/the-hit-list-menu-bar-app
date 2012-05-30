framework 'AppKit'
framework 'ScriptingBridge'

BLACK = NSImage.new.initWithContentsOfFile (NSBundle.mainBundle.resourcePath + '/status_black.png')
COLOR = NSImage.new.initWithContentsOfFile (NSBundle.mainBundle.resourcePath + '/status_color.png')
HITLIST = SBApplication.applicationWithBundleIdentifier("com.potionfactory.TheHitList")

@task_items = []

def setupMenu
  @menu = NSMenu.new
  @menu.initWithTitle 'The Hit List'

  @menu.addItem NSMenuItem.separatorItem

  mi = NSMenuItem.new
  mi.title = 'Reload'
  mi.action = 'reload:'
  mi.target = self
  @menu.addItem mi

  mi = NSMenuItem.new
  mi.title = 'Quit'
  mi.action = 'quit:'
  mi.target = self
  @menu.addItem mi

  @menu
end

def initStatusBar(menu)
  status_bar = NSStatusBar.systemStatusBar
  @status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
  @status_item.setMenu menu
  @status_item.setImage(BLACK)
end

def tasks()
  HITLIST.todayList.tasks.select{|t| t.completed == false }
end


def task_count(sender = nil)
  tasks.size
end

def render_task_list
  @task_items.each do |item|
    @menu.removeItem item
  end
  @task_items = []

  tasks.each do |task|
    mi = NSMenuItem.new
    mi.title = task.title
    mi.target = self
    @menu.insertItem mi, atIndex: 0
    @task_items << mi
  end
end

def reload(sender = nil)
  count = task_count
  if count > 0
    title = count.to_s
    img = COLOR
  else
    title = nil
    img = BLACK
  end
  @status_item.setImage(img)
  @status_item.setAttributedTitle(title)
  render_task_list
end

def runner
  Thread.new do
    loop do
      reload
      sleep 10
    end
  end
end

def quit(sender)
  app = NSApplication.sharedApplication
  app.terminate(self)
end

app = NSApplication.sharedApplication
initStatusBar(setupMenu)
runner
app.run