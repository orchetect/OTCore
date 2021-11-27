//
//  CharacterSet.swift
//  OTCore • https://github.com/orchetect/OTCore
//

#if canImport(Foundation)

import Foundation

extension CharacterSet {
    
    /// **OTCore:**
    /// Returns true if the `CharacterSet` contains the given `Character`.
    public func contains(_ character: Character) -> Bool {
        
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
        
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
