//
//  ScriptsBuilder.swift
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

import Foundation

struct ScriptsBuilder {
    
    enum ScriptType {
        case FullScreen
        case SwitchMainTab
        case SwitchNavigatorTab
        case SwitchInspectorTab
        case ToggleDebugConsole
        case MoveMouse
        case Click
        case Scroll
    }
    
    enum ArgsKey {
        case PositionX, PositionY, NavigatorTab, InspectorTab, ScrollDirection, DebugConsoleVisibility
    }
    
    enum ScrollDirection {
        case Up, Down
    }
    
    enum NavigatorTab: Int {
        case Hide = 0, Project, Symbol, Find, Issue, Test, Debug, Breakpoints, Report
    }

    enum InspectorTab: Int {
        case Hide = 0, File, Help, Identity, Attributes, Size, Connections, Bindings, Effects
    }
    
    static func build(scriptType: ScriptType, args: Dictionary<ArgsKey, Any>? = nil) -> Scriptable {
        switch scriptType {
        case .FullScreen:         return buildFullScreenScript()
        case .SwitchMainTab:      return buildSwitchMainTabScript()
        case .SwitchNavigatorTab: return buildSwitchNavigatorTabScript(args)
        case .SwitchInspectorTab: return buildSwitchInspectorTabScript(args)
        case .ToggleDebugConsole: return buildToggleDebugConsoleScript()
        case .MoveMouse:          return buildMouseMoveScript(args)
        case .Click:              return buildClickScript(args)
        case .Scroll:             return buildScrollScript(args)
        }
    }
}

private extension ScriptsBuilder {

    static func buildFullScreenScript() -> Scriptable {
        let query = "tell application \"Xcode\" to activate\n" +
                    "set isfullscreen to false\n" +
                    "tell application \"System Events\" to tell process \"Xcode\"\n" +
                    "   set isfullscreen to value of attribute \"AXFullScreen\" of window 1\n" +
                    "   if isfullscreen is false then\n" +
                    "       tell application \"System Events\" to keystroke \"f\" using { command down, control down }\n" +
                    "   end if\n" +
                    "end tell\n"
        return NSAppleScript(source: query)!
    }
    
    static func buildSwitchMainTabScript() -> Scriptable {
        let query = "tell application \"Xcode\" to activate\n" +
                    "tell application \"System Events\"\n" +
                    "    tell process \"Xcode\"\n" +
                    "        tell menu bar 1\n" +
                    "            tell menu bar item \"Window\"\n" +
                    "                tell menu \"Window\"\n" +
                    "                    click menu item \"Show Next Tab\"\n" +
                    "                end tell\n" +
                    "            end tell\n" +
                    "        end tell\n" +
                    "    end tell\n" +
                    "end tell\n"
        return NSAppleScript(source: query)!
    }

    static func buildSwitchNavigatorTabScript(args: Dictionary<ArgsKey, Any>?) -> Scriptable {
        var tabCode = 29
        if let args = args,
            tabValue = args[ArgsKey.NavigatorTab] as? NavigatorTab {
            switch tabValue {
            case .Hide:         tabCode = 29
            case .Project:      tabCode = 18
            case .Symbol:       tabCode = 19
            case .Find:         tabCode = 20
            case .Issue:        tabCode = 21
            case .Test:         tabCode = 23
            case .Debug:        tabCode = 22
            case .Breakpoints:  tabCode = 26
            case .Report:       tabCode = 28
            }
        }
        let query = "tell application \"Xcode\" to activate\n" +
                    "tell application \"System Events\"\ntell process \"Xcode\"\n" +
                    "    key code {\(tabCode)} using {command down}\n" +
                    "end tell\nend tell\n"
        return NSAppleScript(source: query)!
    }

    static func buildSwitchInspectorTabScript(args: Dictionary<ArgsKey, Any>?) -> Scriptable {
        var tabCode = 29
        if let args = args,
            tabValue = args[ArgsKey.InspectorTab] as? InspectorTab {
            switch tabValue {
            case .Hide:         tabCode = 29
            case .File:         tabCode = 18
            case .Help:         tabCode = 19
            case .Identity:     tabCode = 20
            case .Attributes:   tabCode = 21
            case .Size:         tabCode = 23
            case .Connections:  tabCode = 22
            case .Bindings:     tabCode = 26
            case .Effects:      tabCode = 28
            }
        }
        let query = "tell application \"Xcode\" to activate\n" +
                    "tell application \"System Events\" to tell process \"Xcode\"\n" +
                    "    key code {\(tabCode)} using {command down, option down}\n" +
                    "end tell\n"
        return NSAppleScript(source: query)!
    }
    
    static func buildToggleDebugConsoleScript() -> Scriptable {
        let query = "tell application \"Xcode\" to activate\n" +
                    "tell application \"System Events\" to tell process \"Xcode\"\n" +
                    "    keystroke \"Y\" using {command down, shift down}\n" +
                    "end tell\n"
        return NSAppleScript(source: query)!
    }

    static func buildMouseMoveScript(args: Dictionary<ArgsKey, Any>?) -> Scriptable {
        let position = positionFromArguments(args)
        return MoveMouseAct(position: position)
    }
    
    static func buildScrollScript(args: Dictionary<ArgsKey, Any>?) -> Scriptable {
        var direction = ScrollDirection.Up
        if let args = args, directionValue = args[ArgsKey.ScrollDirection] as? ScrollDirection {
            direction = directionValue
        }
        return ScrollMouseAct(wheel: direction == ScrollDirection.Up ? 5 : -5)
    }

    static func buildClickScript(args: Dictionary<ArgsKey, Any>?) -> Scriptable {
        let position = positionFromArguments(args)
        return ClickMouseAct(position: position)
    }
}

// MARK: - Helpers

private extension ScriptsBuilder {
    static func positionFromArguments(args: Dictionary<ArgsKey, Any>?) -> CGPoint {
        var position = CGPointZero // TODO: change to middle of the current app window or screen
        if let args = args, x = args[ArgsKey.PositionX] as? Int, y = args[ArgsKey.PositionY] as? Int {
            position.x = CGFloat(x)
            position.y = CGFloat(y)
        }
        return position
    }
}
