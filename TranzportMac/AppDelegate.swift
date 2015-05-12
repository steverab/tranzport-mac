//
//  AppDelegate.swift
//  TranzportMac
//
//  Created by Stephan Rabanser on 12/05/15.
//  Copyright (c) 2015 Stephan Rabanser. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var button: NSButton!
    
    let statusBar = NSStatusBar.systemStatusBar()
    let apiWrapper = APIWrapper()
    var statusBarItem = NSStatusItem()
    
    let menu = NSMenu()
    let settingsMenuItem = NSMenuItem()
    let quitMenuItem = NSMenuItem()
    
    var departures: [Departure]!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.window!.orderOut(self)
        refresh()
        var timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("refresh"), userInfo: nil, repeats: true)
    }
    
    override func awakeFromNib() {
        //setup()
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
    }
    
    func refresh() {
        apiWrapper.fetchDepartures({ (departures) -> Void in
            self.departures = departures
            self.setup()
            }, failure: { (error) -> Void in
                
        })
    }
    
    func setup() {
        statusBarItem.title = departures.first?.description
        
        menu.removeAllItems()
        
        for dep in departures {
            let depItem = NSMenuItem()
            depItem.title = dep.description
            depItem.action = nil
            depItem.keyEquivalent = ""
            menu.addItem(depItem)
        }
        
        menu.addItem(NSMenuItem.separatorItem())
        
        settingsMenuItem.title = "Settings"
        settingsMenuItem.action = Selector("setWindowVisible:")
        settingsMenuItem.keyEquivalent = ""
        menu.addItem(settingsMenuItem)
        
        quitMenuItem.title = "Quit"
        quitMenuItem.action = Selector("quitApp")
        quitMenuItem.keyEquivalent = ""
        menu.addItem(quitMenuItem)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func buttonPressed(sender: NSButton) {
    }
    
    func setWindowVisible(sender: AnyObject){
        self.window!.orderFront(self)
    }
    
    func quitApp() {
        exit(0)
    }

}

