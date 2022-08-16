//
//  Globals.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

// MARK: - Global bundle properties

/// **OTCore:**
/// Global convenience properties
public enum Globals {
    /// General main bundle-related
    public enum MainBundle {
        /// **OTCore:**
        /// Returns the name of the current executable.
        public static let name: String = Bundle.main
            .infoDictionaryString(key: kCFBundleNameKey)
            ?? ""
        
        /// **OTCore:**
        /// Returns the current executable's bundle ID.
        /// Returns an empty string in case of failure.
        public static let bundleID: String = Bundle.main
            .bundleIdentifier
            ?? ""
        
        /// **OTCore:**
        /// Returns the value of the current executable's Info.plist `CFBundleShortVersionString` key.
        /// Returns an empty string in case of failure or if the key does not exist in the bundle's Info.plist.
        public static let versionShort: String = Bundle.main
            .infoDictionaryString(key: "CFBundleShortVersionString")
            ?? ""
        
        /// **OTCore:**
        /// Returns the major version number from the value of the current executable's Info.plist `CFBundleShortVersionString` key.
        /// Returns 0 in case of failure or if the key does not exist in the bundle's Info.plist.
        public static let versionMajor: Int = .init(
            versionShort
                .components(separatedBy: ".")
                .first ?? "0"
        ) ?? 0
        
        /// **OTCore:**
        /// Returns the value from the app bundle's `kCFBundleVersionKey` key
        public static let versionBuildNumber: String = Bundle.main
            .infoDictionaryString(key: kCFBundleVersionKey)
            ?? ""
    }
}

// MARK: - Global system properties

extension Globals {
    /// **OTCore:**
    /// System-related globals.
    public enum System {
        /// **OTCore:**
        /// Returns the username of the current system account.
        @available(macOS 10.12, *)
        @available(macCatalyst, unavailable)
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        public static var userName: String {
            #if os(macOS)
            return ProcessInfo.processInfo.fullUserName
            #else
            fatalError("Not implemented on this platform yet.")
            #endif
        }
        
        /// **OTCore:**
        /// Returns the full username of the current system account.
        @available(macOS 10.12, *)
        @available(macCatalyst, unavailable)
        @available(iOS, unavailable)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        public static var fullUserName: String {
            #if os(macOS)
            return ProcessInfo.processInfo.userName
            #else
            fatalError("Not implemented on this platform yet.")
            #endif
        }
        
        /// **OTCore:**
        /// Returns the operating system version on the system.
        public static var osVersion: String {
            ProcessInfo.processInfo.operatingSystemVersionString
        }
        
        /// **OTCore:**
        /// On macOS, returns Mac computer name. On iOS/tvOS, returns device name.
        @available(macOS 10.6, macCatalyst 13, iOS 2, tvOS 9, *)
        @available(watchOS, unavailable)
        public static var name: String {
            #if os(macOS)
            return Host.current().localizedName ?? ""
            #elseif os(iOS) || os(tvOS)
            return UIDevice.current.name
            #else
            fatalError("Not implemented on this platform yet.")
            #endif
        }
        
        #if os(macOS)
        
        /// **OTCore:**
        /// Returns local Mac's mainboard serial number.
        /// (Computes lazily, once upon first access and retains value persistently until app quits.)
        public static let serialNumber: String? = Self
            .getSysInfoString(key: kIOPlatformSerialNumberKey)
        
        /// **OTCore:**
        /// Returns local Mac's hardware UUID string.
        /// (Computes lazily, once upon first access and retains value persistently until app quits.)
        public static let hardwareUUID: String? = Self.getSysInfoString(key: kIOPlatformUUIDKey)
        
        /// Internal use.
        internal static func getSysInfoString(key: String) -> String? {
            let platformExpert = IOServiceGetMatchingService(
                kIOMasterPortDefault,
                IOServiceMatching("IOPlatformExpertDevice")
            )
            
            defer {
                IOObjectRelease(platformExpert)
            }
            
            guard platformExpert > 0 else {
                return nil
            }
            
            guard let serialNumber =
                IORegistryEntryCreateCFProperty(
                    platformExpert,
                    key as CFString,
                    kCFAllocatorDefault,
                    0
                )
                .takeUnretainedValue() as? String
            else {
                return nil
            }
            
            return serialNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        #endif
    }
}

extension Bundle {
    /// **OTCore:**
    /// Convenience function to return an Info.plist key value as a String.
    public func infoDictionaryString(key: String) -> String? {
        infoDictionary?[key] as? String
    }
    
    /// **OTCore:**
    /// Convenience function to return an Info.plist key value as a String.
    public func infoDictionaryString(key: CFString) -> String? {
        infoDictionary?[key as String] as? String
    }
}
