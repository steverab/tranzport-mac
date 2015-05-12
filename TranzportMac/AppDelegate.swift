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
    var statusBarItem = NSStatusItem()
    
    let menu = NSMenu()
    let settingsMenuItem = NSMenuItem()
    let quitMenuItem = NSMenuItem()
    
    var departures = ["U6 → Klin.-Gr. in 1 min", "U6 → Garch.-F. in 8 min", "U6 → Klin.-Gr. in 11 min", "U6 → Garch.-F. in 19 min"]

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.window!.orderOut(self)
    }
    
    override func awakeFromNib() {
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
        statusBarItem.title = departures.first
        
        for dep in departures {
            let depItem = NSMenuItem()
            depItem.title = dep
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

