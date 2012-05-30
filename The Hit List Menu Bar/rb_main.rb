#
#  rb_main.rb
#  The Hit List Menu Bar
#
#  Created by Jonas Forsberg on 2012-05-30.
#  Copyright (c) 2012 Mynewsdesk. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'AppKit'

BLACK = NSImage.new.initWithContentsOfFile (NSBundle.mainBundle.resourcePath + '/status_black.png')
COLOR = NSImage.new.initWithContentsOfFile (NSBundle.mainBundle.resourcePath + '/status_color.png')

def setupMenu
    menu = NSMenu.new
    menu.initWithTitle 'The Hit List'
    
    mi = NSMenuItem.new
    mi.title = 'Reload'
    mi.action = 'reload:'
    mi.target = self
    menu.addItem mi
    
    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'quit:'
    mi.target = self
    menu.addItem mi
    
    menu
end

def initStatusBar(menu)
    status_bar = NSStatusBar.systemStatusBar
    @status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    @status_item.setMenu menu
    @status_item.setImage(BLACK)
end

def task_count(sender = nil)
    `osascript -e 'tell application \"The Hit List\" to count (tasks of today list whose completed is false)'`.to_i
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
end

def runner
    Thread.new do
        loop do
            reload
            sleep 5
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