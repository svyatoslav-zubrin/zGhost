//
//  PreferencesManager.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/27/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation
import AppKit

protocol Preferences {
    
    var shouldMoveMouse: Bool { get }
    var shouldScroll: Bool { get }
    var shouldClick: Bool { get }
    var shouldMaximiseXcode: Bool { get }
    var shouldSwitchMainTabs: Bool { get }
    var shouldSwitchNavigatorTabs: Bool { get }
    var shouldSwitchInspectorTabs: Bool { get }
    var shouldToggleDebugConsole: Bool { get }
    var eventsFrequency: Int { get }

    var defaults: Dictionary<String, AnyObject> { get }

    func show()
}

class PreferencesManager {

    internal struct PreferencesKeys {
        static let MoveMouse            = "Preferences.MoveMouse"
        static let Scroll               = "Preferences.Scroll"
        static let Click                = "Preferences.Click"
        static let FullScreen           = "Preferences.FullScreen"
        static let SwitchMainTab        = "Preferences.SwitchMainTab"
        static let SwitchNavigatorTab   = "Preferences.SwitchNavigatorTab"
        static let SwitchInspectorTab   = "Preferences.SwitchInspectorTab"
        static let ToggleDebugConsole   = "Preferences.ToggleDebugConsole"
        static let EventsFrequency      = "Preferences.EventsFrequency"
    }
    
    private var prefsWindowController: PreferencesWindowController?
    
    private func showPreferences() {
        prefsWindowController = PreferencesWindowController(windowNibName: "Settings")
        prefsWindowController!.preferencesManager = self
        if let prefsWindowController = prefsWindowController {
            prefsWindowController.showWindow(nil)
        }
    }
    
    private func loadPreferenceForKey<T>(key: String, defaultValue: T) -> T {
        if let value = NSUserDefaults.standardUserDefaults().valueForKey(key) as? T {
            return value
        } else if let value = defaults[key] as? T {
            return value
        } else {
            return defaultValue
        }
    }
}

extension PreferencesManager: Preferences {
    
    var shouldMoveMouse: Bool {
        return loadPreferenceForKey(PreferencesKeys.MoveMouse, defaultValue: true)
    }
    
    var shouldScroll: Bool {
        return loadPreferenceForKey(PreferencesKeys.Scroll, defaultValue: true)
    }
    
    var shouldClick: Bool {
        return loadPreferenceForKey(PreferencesKeys.Click, defaultValue: false)
    }
    
    var shouldMaximiseXcode: Bool {
        return loadPreferenceForKey(PreferencesKeys.FullScreen, defaultValue: true)
    }
    
    var shouldSwitchMainTabs: Bool {
        return loadPreferenceForKey(PreferencesKeys.SwitchMainTab, defaultValue: true)
    }
    
    var shouldSwitchNavigatorTabs: Bool {
        return loadPreferenceForKey(PreferencesKeys.SwitchNavigatorTab, defaultValue: true)
    }
    
    var shouldSwitchInspectorTabs: Bool {
        return loadPreferenceForKey(PreferencesKeys.SwitchInspectorTab, defaultValue: true)
    }
    
    var shouldToggleDebugConsole: Bool {
        return loadPreferenceForKey(PreferencesKeys.ToggleDebugConsole, defaultValue: true)
    }
    
    var eventsFrequency: Int {
        return loadPreferenceForKey(PreferencesKeys.EventsFrequency, defaultValue: 30)
    }
    
    func show() {
        showPreferences()
    }
    
    var defaults: Dictionary<String, AnyObject> {
        return [
            PreferencesKeys.FullScreen: true,
            PreferencesKeys.MoveMouse: true,
            PreferencesKeys.Scroll: true,
            PreferencesKeys.Click: false,
            PreferencesKeys.SwitchMainTab: true,
            PreferencesKeys.SwitchInspectorTab: true,
            PreferencesKeys.SwitchNavigatorTab: true,
            PreferencesKeys.ToggleDebugConsole: true,
            PreferencesKeys.EventsFrequency: 30,
        ]
    }
}