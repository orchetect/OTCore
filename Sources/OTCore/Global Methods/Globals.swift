//
//  Globals.swift
//  OTCore
//
//  Created by Steffan Andrews on 2021-01-12.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

// MARK: - Global bundle properties

/// OTCore:
/// Global convenience properties
public enum Globals {
	
	/// General main bundle-related
	public struct bundle {
		
		/// OTCore:
		/// Returns the name of the app
		public static let name: String = Bundle.mainInfoDictionary(key: kCFBundleNameKey) ?? ""
		
		/// OTCore:
		/// Returns the app's bundle ID
		public static let bundleID: String = Bundle.main.bundleIdentifier ?? ""
		
		/// OTCore:
		/// Returns the value of the app bundle's `CFBundleShortVersionString` key
		public static let versionShort: String = Bundle.mainInfoDictionary(key: "CFBundleShortVersionString" as CFString) ?? ""
		
		/// OTCore:
		/// Returns the major version number from the value of the app bundle's `CFBundleShortVersionString` key
		public static let versionMajor: Int = Int(versionShort.components(separatedBy: ".").first ?? "0") ?? 0
		
		/// OTCore:
		/// Returns the value from the app bundle's `kCFBundleVersionKey` key
		public static let versionBuildNumber: String = Bundle.mainInfoDictionary(key: kCFBundleVersionKey) ?? ""
	
	}
	
}


// MARK: - Global system properties

extension Globals {
	
	/// OTCore:
	/// General system-related
	public enum system {
		
		#if os(macOS)
		/// OTCore:
		/// Local Mac computer name
		public static var name: String {
			Host.current().localizedName ?? ""
		}
		#elseif os(iOS) || os(tvOS)
		/// OTCore:
		/// Local device name
		public static var name: String {
			UIDevice.current.name
		}
		#endif
		
		#if os(macOS)
		
		/// OTCore:
		/// Returns local Mac's mainboard serial number.
		/// (Computes lazily, once upon first access and retains value persistently until app quits.)
		public static let serialNumber: String? = Self.getSysInfoString(key: kIOPlatformSerialNumberKey)
		
		/// OTCore:
		/// Returns local Mac's hardware UUID string.
		/// (Computes lazily, once upon first access and retains value persistently until app quits.)
		public static let hardwareUUID: String? = Self.getSysInfoString(key: kIOPlatformUUIDKey)
		
		/// Internal use.
		internal static func getSysInfoString(key: String) -> String? {
			
			let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
			
			defer {
				IOObjectRelease(platformExpert)
			}
			
			guard platformExpert > 0 else {
				return nil
			}
			
			guard let serialNumber =
					IORegistryEntryCreateCFProperty(platformExpert,
													key as CFString,
													kCFAllocatorDefault,
													0)
					.takeUnretainedValue() as? String
			else {
				return nil
			}
			
			return serialNumber.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
			
		}
		
		#endif
		
	}
}

extension Bundle {
	
	/// OTCore:
	/// Convenience function to get bundle data
	public class func mainInfoDictionary(key: String) -> String? {
		self.main.infoDictionary?[key] as? String
	}
	
	/// OTCore:
	/// Convenience function to get bundle data
	public class func mainInfoDictionary(key: CFString) -> String? {
		self.main.infoDictionary?[key as String] as? String
	}
	
}

