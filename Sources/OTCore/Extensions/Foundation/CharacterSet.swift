//
//  CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
    
    /// **OTCore:**
    /// Initialize a `CharacterSet` from one or more `Character`.
    public init(_ characters: Character...) {
        
        self.init(characters)
        
    }
    
    /// **OTCore:**
    /// Initialize a `CharacterSet` from one or more `Character`.
    public init(_ characters: [Character]) {
        
        self.init()

        characters.forEach {
            $0.unicodeScalars.forEach { insert($0) }
        }
        
    }
    
}

extension CharacterSet {
    
    /// **OTCore:**
    /// Returns true if the `CharacterSet` contains the given `Character`.
    @_disfavoredOverload
    public func contains(_ character: Character) -> Bool {
        
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
        
    }
    
}

extension CharacterSet {
    
    /// **OTCore:**
    /// Same as `lhs.union(rhs)`.
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.formUnion(rhs)`.
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.subtracting(rhs)`.
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.subtract(rhs)`.
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs)
    }
    
}

extension CharacterSet {
    
    /// **OTCore:**
    /// English consonant letters, omitting vowels.
    public static var consonants = CharacterSet.letters.subtracting(Self.vowels)
    
    /// **OTCore:**
    /// English vowel letters (a, e, i, o, u) including all cases and diacritic variants.
    public static var vowels = lowercaseVowels.union(uppercaseVowels)
    
    /// **OTCore:**
    /// English lowercase vowel letters (a, e, i, o, u) including diacritic variants.
    public static var lowercaseVowels = CharacterSet(
        charactersIn:
            "aàáâäæãåā" + "ª" + "ăąǟǻȁȃȧᵃḁạảấầẩẫậắằẳẵặ"
        + "eèéêëēėę" + "ĕėěȅȇȩᵉḕḗḙḛḝẹẻẽếềểễệ"
        + "iîïíīįì" + "ĩĭįıǐȉȋᵢḭḯỉịⁱ"
        + "oôöòóœøōõ" + "ŏőơǒǫǭȍȏȫȭȯȱᵒṍṏṑṓọỏốồổỗộ"
        + "uûüùúū" + "ũŭůűųưǔǖǘǚǜȕȗᵘᵤṳṵṷṹṻụủứừửữự"
    )
    
    /// **OTCore:**
    /// English uppercase vowel letters (a, e, i, o, u) including diacritic variants.
    public static var uppercaseVowels = CharacterSet(
        charactersIn:
            "AÀÁÂÄÆÃÅĀ" + "ĂĄǞǺȀȂȦᴬḀẠẢẤẦẨẪẬẮẰẲẴẶ"
        + "EÈÉÊËĒĖĘ" + "ĔĖĚȄȆȨᴱḔḖḘḚḜẸẺẼẾỀỀỂỄỆ"
        + "IÎÏÍĪĮÌ" + "ĨĬĮİǏȈȊᴵḬḮỈỊ"
        + "OÔÖÒÓŒØŌÕ" + "ŎŐƠǑǪǬȌȎȪȬȮȰᴼṌṎṐṒỌỎỐỒỔỖỘỚ"
        + "UÛÜÙÚŪ" + "ŨŬŮŰŲƯǓǕǗǙǛȔȖᵁṲṴṶṸṺỤỦỨỪỬỮỰ"
    )
    
}

#endif
