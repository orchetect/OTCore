//
//  CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
    /// **OTCore:**
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
    public init(_ characters: Character...) {
        self.init(characters)
    }
    
    /// **OTCore:**
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
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
        // TODO: this may not be correct, it could match scalars non-sequentially
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
    }
}

extension CharacterSet {
    /// **OTCore:**
    /// Same as `lhs.union(rhs)`.
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.formUnion(rhs)`.
    @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.subtracting(rhs)`.
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs)
    }
    
    /// **OTCore:**
    /// Same as `lhs.subtract(rhs)`.
    @_disfavoredOverload
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs)
    }
}

extension CharacterSet {
    /// **OTCore:**
    /// English consonant letters, omitting vowels.
    @_disfavoredOverload
    public static let consonants = CharacterSet.letters.subtracting(Self.vowels)
    
    /// **OTCore:**
    /// English vowel letters (a, e, i, o, u) including all cases and diacritic variants.
    @_disfavoredOverload
    public static let vowels = lowercaseVowels.union(uppercaseVowels)
    
    /// **OTCore:**
    /// English lowercase vowel letters (a, e, i, o, u) including diacritic variants.
    @_disfavoredOverload
    public static let lowercaseVowels = CharacterSet(charactersIn:
        "aàáâäæãåā" + "ª" + "ăąǟǻȁȃȧᵃḁạảấầẩẫậắằẳẵặ"
            + "eèéêëēėę" + "ĕėěȅȇȩᵉḕḗḙḛḝẹẻẽếềểễệ"
            + "iîïíīįì" + "ĩĭįıǐȉȋᵢḭḯỉịⁱ"
            + "oôöòóœøōõ" + "ŏőơǒǫǭȍȏȫȭȯȱᵒṍṏṑṓọỏốồổỗộ"
            + "uûüùúū" + "ũŭůűųưǔǖǘǚǜȕȗᵘᵤṳṵṷṹṻụủứừửữự"
    )
    
    /// **OTCore:**
    /// English uppercase vowel letters (a, e, i, o, u) including diacritic variants.
    @_disfavoredOverload
    public static let uppercaseVowels = CharacterSet(charactersIn:
        "AÀÁÂÄÆÃÅĀ" + "ĂĄǞǺȀȂȦᴬḀẠẢẤẦẨẪẬẮẰẲẴẶ"
            + "EÈÉÊËĒĖĘ" + "ĔĖĚȄȆȨᴱḔḖḘḚḜẸẺẼẾỀỀỂỄỆ"
            + "IÎÏÍĪĮÌ" + "ĨĬĮİǏȈȊᴵḬḮỈỊ"
            + "OÔÖÒÓŒØŌÕ" + "ŎŐƠǑǪǬȌȎȪȬȮȰᴼṌṎṐṒỌỎỐỒỔỖỘỚ"
            + "UÛÜÙÚŪ" + "ŨŬŮŰŲƯǓǕǗǙǛȔȖᵁṲṴṶṸṺỤỦỨỪỬỮỰ"
    )
}

#endif
