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
    
    // MARK: Outlets

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var stationTextField: NSTextField!
    @IBOutlet weak var launchAtLoginButton: NSButton!
    @IBOutlet weak var intervalSlider: NSSlider!
    @IBOutlet weak var intervalLabel: NSTextField!
    @IBOutlet weak var autoRefreshButton: NSButton!
    
    // MARK: Statusbar
    
    let statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem = NSStatusItem()
    
    // MARK: Menu
    
    let menu = NSMenu()
    let refreshMenuItem = NSMenuItem()
    let settingsMenuItem = NSMenuItem()
    let quitMenuItem = NSMenuItem()
    
    // MARK: Other
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let apiWrapper = APIWrapper()
    var timer: NSTimer!
    var departures: [Departure]!
    
    //-------------------------------------------------------------------------//
    //-------------------------------------------------------------------------//
    //-------------------------------------------------------------------------//
    
    // MARK: - App lifecycle

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.window!.orderOut(self)
        setFirstLaunchOptions()
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
        setupFixedMenuItems()
        setupTimer()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    // MARK: - First launch config
    
    func setFirstLaunchOptions() {
        if !defaults.boolForKey("firstLaunch") {
            defaults.setBool(true, forKey: "firstLaunch")
            defaults.setObject("Garching", forKey: "station")
            defaults.setInteger(30, forKey: "refreshInterval")
            defaults.setBool(true, forKey: "autorefresh")
        }
    }
    
    // MARK: - Timer and refresh logic
    
    func setupTimer() {
        refresh()
        
        if defaults.boolForKey("autorefresh") {
            if timer != nil {
                timer.invalidate()
            }
            let interval = defaults.integerForKey("refreshInterval")
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(interval), target: self, selector: Selector("refresh"), userInfo: nil, repeats: true)
        }
        
    }
    
    func refresh() {
        apiWrapper.fetchDepartures({ (departures) -> Void in
            self.departures = departures
            self.setupMenuItems()
        }, failure: { (error) -> Void in
            self.departures = []
            self.setupMenuItems()
        })
    }
    
    // MARK: - Dynamic menu item config
    
    func setupMenuItems() {
        menu.removeAllItems()
        
        if departures.count != 0 {
            statusBarItem.title = departures.first?.shortenedDescription
            
            for dep in departures {
                let depItem = NSMenuItem()
                depItem.title = dep.description
                depItem.action = nil
                depItem.keyEquivalent = ""
                menu.addItem(depItem)
            }
        } else {
            statusBarItem.title = "⚠"
            
            var noItemsItem = NSMenuItem()
            noItemsItem.title = "No departures available"
            noItemsItem.action = nil
            menu.addItem(noItemsItem)
            
            noItemsItem = NSMenuItem()
            noItemsItem.title = "Check station spelling and internet connection"
            noItemsItem.action = nil
            menu.addItem(noItemsItem)
        }
        
        addFixedMenuItems()
    }
    
    // MARK: - Fixed menu item config
    
    func setupFixedMenuItems() {
        refreshMenuItem.title = "Refresh"
        refreshMenuItem.action = Selector("refresh")
        refreshMenuItem.keyEquivalent = ""
        menu.addItem(refreshMenuItem)
        
        settingsMenuItem.title = "Settings"
        settingsMenuItem.action = Selector("setWindowVisible:")
        settingsMenuItem.keyEquivalent = ""
        
        quitMenuItem.title = "Quit"
        quitMenuItem.action = Selector("quitApp")
        quitMenuItem.keyEquivalent = ""
    }
    
    func addFixedMenuItems() {
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(refreshMenuItem)
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(settingsMenuItem)
        menu.addItem(quitMenuItem)
    }
    
    // MARK: - Menu item actions
    
    func setWindowVisible(sender: AnyObject){
        stationTextField.stringValue = defaults.objectForKey("station") as! String
        intervalSlider.integerValue = defaults.integerForKey("refreshInterval")
        
        if defaults.boolForKey("autorefresh") {
            autoRefreshButton.state = NSOnState
            intervalSlider.enabled = true
            let interv = defaults.integerForKey("refreshInterval")
            intervalLabel.stringValue = "Current interval: \(interv) seconds"
        } else {
            autoRefreshButton.state = NSOffState
            intervalSlider.enabled = false
            intervalLabel.stringValue = "Current interval: -"
        }
        
        if StartupLaunch.isAppLoginItem() {
            launchAtLoginButton.state = NSOnState
        } else {
            launchAtLoginButton.state = NSOffState
        }
        self.window!.makeKeyAndOrderFront(self)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func quitApp() {
        exit(0)
    }
    
    // MARK: - Button actions
    
    @IBAction func stationButtonPressed(sender: NSButton) {
        defaults.setObject(stationTextField.stringValue, forKey: "station")
        window.makeFirstResponder(nil)
        refresh()
    }
    
    @IBAction func launchLoginBoxChecked(sender: NSButton) {
        if sender.state == NSOnState {
            StartupLaunch.setLaunchOnLogin(true)
        } else {
            StartupLaunch.setLaunchOnLogin(false)
        }
    }
    
    @IBAction func autorefreshButtonChecked(sender: NSButton) {
        if sender.state == NSOnState {
            defaults.setBool(true, forKey: "autorefresh")
            intervalSlider.enabled = true
            let interv = defaults.integerForKey("refreshInterval")
            intervalLabel.stringValue = "Current interval: \(interv) seconds"
            setupTimer()
        } else {
            defaults.setBool(false, forKey: "autorefresh")
            intervalSlider.enabled = false
            intervalLabel.stringValue = "Current interval: -"
            timer.invalidate()
        }
    }
    
    @IBAction func sliderValueChanged(sender: NSSlider) {
        defaults.setInteger(sender.integerValue, forKey: "refreshInterval")
        intervalLabel.stringValue = "Current interval: \(sender.integerValue) seconds"
        setupTimer()
    }

}

