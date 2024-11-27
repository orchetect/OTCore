//
//  DomainName.swift
//  OTCore • https://github.com/orchetect/OTCore
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A type representing a domain name (ie: `apple.com`, `www.apple.com`, `sub.domain.www.zzz`).
public struct DomainName {
    /// Individual domain name components (domain name split by period (`.`) characters).
    public let components: [String]
    
    /// The number of domain extension components included in the domain extension.
    ///
    /// For example:
    /// - `"www.apple.com"` would have `1` component (`"com"`).
    /// - `"www.apple.co.uk"` would have `2` components (`"co"` and `"uk"`).
    public let extensionComponentCount: Int
    
    /// Initialize a new instance from a domain name string.
    public init(_ verbatim: String) {
        components = verbatim.split(separator: ".").map(String.init)
        extensionComponentCount = Self.extensionComponentCount(inDomainComponents: components)
    }
    
    /// Initialize a new instance from domain name components (domain name split by period (`.`) characters).
    public init(components: [String]) {
        self.components = components
        extensionComponentCount = Self.extensionComponentCount(inDomainComponents: components)
    }
}

extension DomainName: Equatable { }

extension DomainName: Hashable { }

extension DomainName: Identifiable {
    public var id: String { string }
}

extension DomainName: CustomStringConvertible {
    public var description: String {
        string
    }
}

extension DomainName {
    /// Returns the full domain name string including all components.
    public var string: String {
        components.joined(separator: ".")
    }
    
    /// Returns the prefix components of the domain name, if any are present.
    ///
    /// For example:
    /// - `"apple.com"` or `"apple.co.uk"` returns `""`
    /// - `"www.apple.com"` or `"www.apple.co.uk"` returns `"www"`
    /// - `"zzz.www.apple.com"` returns `"zzz.www"`
    public var prefix: String {
        prefixComponents.joined(separator: ".")
    }
    
    /// Returns the prefix components of the domain name, if any are present.
    ///
    /// For example:
    /// - `"apple.com"` or `"apple.co.uk"` returns `[]`
    /// - `"www.apple.com"` or `"www.apple.co.uk"` returns `["www"]`
    /// - `"zzz.www.apple.com"` returns `["zzz", "www"]`
    public var prefixComponents: [String] {
        let prefixCount = max(0, components.count - (extensionComponentCount + 1))
        return Array(components.prefix(prefixCount))
    }
    
    /// Returns the domain component of the domain name.
    ///
    /// For example:
    /// - `"apple.com"` or `"www.apple.com"` returns `"apple"`
    /// - `"apple.co.uk"` or `"www.apple.co.uk"` returns `"apple"`
    public var domainComponent: String {
        components.dropLast(extensionComponentCount).last ?? ""
    }
    
    /// Returns the domain and extension of the domain name.
    ///
    /// For example:
    /// - `"apple.com"` or `"www.apple.com"` returns `"apple.com"`
    /// - `"apple.co.uk"` or `"www.apple.co.uk"` returns `"apple.co.uk"`
    public var domainAndExtension: String {
        domainAndExtensionComponents.joined(separator: ".")
    }
    
    /// Returns the domain and extension of the domain name.
    ///
    /// For example:
    /// - `"apple.com"` or `"www.apple.com"` returns `["apple", "com"]`
    /// - `"apple.co.uk"` or `"www.apple.co.uk"` returns `["apple", "co", "uk"]`
    public var domainAndExtensionComponents: [String] {
        components.suffix(extensionComponentCount + 1)
    }
    
    /// Returns the extension for the domain name.
    ///
    /// For example:
    /// - `"apple.com"` or `"www.apple.com"` returns `"com"`
    /// - `"apple.co.uk"` or `"www.apple.co.uk"` returns `"co.uk"`
    public var domainExtension: String {
        domainExtensionComponents.joined(separator: ".")
    }
    
    /// Returns the extension for the domain name.
    ///
    /// For example:
    /// - `"apple.com"` or `"www.apple.com"` returns `["com"]`
    /// - `"apple.co.uk"` or `"www.apple.co.uk"` returns `["co", "uk"]`
    public var domainExtensionComponents: [String] {
        components.suffix(extensionComponentCount)
    }
}

// MARK: - Utilities

extension DomainName {
    /// List of the most common two-level domain extensions.
    ///
    /// This list is not nearly exhaustive or complete.
    /// See https://publicsuffix.org/list/ for a _very_ exhaustive publicly-maintained list.
    ///
    /// If a domain name does not contain one of these extensions, it is assumed the domain has a single (top) level
    /// domain extension (such as "com").
    ///
    /// Dictionary is keyed by top-level domain, with the value comprising an array of all defined second-level domains.
    ///
    /// See https://en.wikipedia.org/wiki/Second-level_domain
    private static let twoLevelDomainExtensions: [String: [String]] = [
        // Algeria
        "dz": [
            "com",
            "gov",
            "org",
            "edu",
            "asso",
            "pol",
            "art",
            "net",
            "tm",
            "soc"
        ],
        
        // Australia
        "au": [
            "com",
            "net",
            "org",
            "edu",
            "gov",
            "asn",
            "id",
            "csiro"
        ],
        
        // Austria
        "at": [
            "ac",
            "gv",
            "co",
            "or",
            "priv"
        ],
        
        // Bangladesh
        "bd": [
            "com",
            "net",
            "org",
            "edu",
            "ac",
            "info",
            "co",
            "gov",
            "mil",
            "tv"
        ],
        
        // Brazil
        "br": [
            // Generic
            "com",
            "net",
            "wiki",
            "etc",
            // Cultural
            "art",
            "rec",
            "tv",
            "am",
            "fm",
            "radio",
            // Business
            "eco",
            "log",
            "emp",
            "leilao",
            "agr",
            "far",
            "imb",
            "ind",
            "inf",
            "srv",
            "tmp",
            "tur",
            "psi",
            "b",
            // Education
            "edu",
            "g12",
            // Personal
            "blog",
            "nom",
            // Entertainment
            "bet",
            "flog",
            "qsl",
            "vlog",
            "esp",
            // Public Authority
            "gov",
            "mil",
            "def",
            "jus",
            "leg",
            "mp",
            "tc",
            // Geographical
            "9guacu",
            "abc",
            "aju",
            "anani",
            "aparecida",
            "barueri",
            "belem",
            "bhz",
            "boavista",
            "bsb",
            "campinagrande",
            "campinas",
            "caxias",
            "contagem",
            "cuiaba",
            "curitiba",
            "feira",
            "floripa",
            "fortal",
            "foz",
            "goiania",
            "gru",
            "jab",
            "jampa",
            "jdf",
            "joinville",
            "londrina",
            "macapa",
            "maceio",
            "manaus",
            "maringa",
            "morena",
            "natal",
            "niteroi",
            "osasco",
            "palmas",
            "poa",
            "pvh",
            "recife",
            "ribeirao",
            "rio",
            "riobranco",
            "riopreto",
            "salvador",
            "sampa",
            "santamaria",
            "santoandre",
            "saobernardo",
            "saogonca",
            "sjc",
            "slz",
            "sorocaba",
            "the",
            "udi",
            "vix",
            // Professionals
            "adm",
            "adv",
            "arq",
            "ato",
            "bib",
            "bio",
            "bmd",
            "cim",
            "cng",
            "cnt",
            "coz",
            "des",
            "det",
            "ecn",
            "enf",
            "eng",
            "eti",
            "fnd",
            "fot",
            "fst",
            "geo",
            "ggf",
            "jor",
            "lel",
            "mat",
            "med",
            "mus",
            "not",
            "ntr",
            "odo",
            "ppg",
            "pro",
            "psc",
            "rep",
            "slg",
            "taxi",
            "teo",
            "trd",
            "vet",
            "zlg",
            // Technology
            "app",
            "dev",
            "seg",
            "tec",
            // Third Sector
            "coop",
            "ong",
            "org"
        ],
        
        // Canada
        "ca": [
            "ab",
            "bc",
            "mb",
            "nb",
            "nf",
            "nl",
            "ns",
            "nt",
            "nu",
            "on",
            "pe",
            "qc",
            "sk",
            "yk"
        ],
        
        // France (TODO: Not exhaustive)
        "fr": [
            "acovat",
            "aeroport",
            "veterinaire"
        ],
        
        // Hungary
        "hu": [
            "2000",
            "agrar",
            "bolt",
            "city",
            "co",
            "edu",
            "film",
            "forum",
            "games",
            "gov",
            "hotel",
            "info",
            "ingatlan",
            "jogasz",
            "konyvelo",
            "lakas",
            "media",
            "mobi",
            "net",
            "news",
            "org",
            "priv",
            "reklam",
            "shop",
            "sport",
            "suli",
            "tm",
            "tozsde",
            "utazas",
            "video",
            "casino",
            "erotica",
            "erotika",
            "sex",
            "szex"
        ],
        
        // New Zealand
        "nz": [
            // Unmoderated
            "ac",
            "co",
            "geek",
            "gen",
            "kiwi",
            "maori",
            "net",
            "org",
            "school",
            // Moderated
            "cri",
            "govt",
            "health",
            "iwi",
            "mil",
            "parliament"
        ],
        
        // Nigeria
        "ng": [
            "com",
            "org",
            "gov",
            "edu",
            "net",
            "sch",
            "name",
            "mobi",
            "mil",
            "i"
        ],
        
        // Pakistan
        "pk": [
            "com",
            "org",
            "net",
            "ac",
            "edu",
            "res",
            "gov",
            "mil",
            "gok",
            "gob",
            "gkp",
            "gop",
            "gos",
            "gog",
            "ltd",
            "web",
            "fam",
            "biz"
        ],
        
        // India
        "in": [
            // General
            "co",
            "com",
            "firm",
            "net",
            "org",
            "gen",
            "ind",
            // Institutions
            "ernet",
            "ac",
            "edu",
            "res",
            "gov",
            "mil",
            "nic",
            // Additional
            "5g",
            "6g",
            "ai",
            "am",
            "bihar",
            "biz",
            "business",
            "ca",
            "cn",
            "com",
            "coop",
            "cs",
            "delhi",
            "dr",
            "er",
            "gujarat",
            "info",
            "int",
            "internet",
            "io",
            "me",
            "pg",
            "post",
            "pro",
            "travel",
            "tv",
            "uk",
            "up",
            "us"
        ],
        
        // Israel
        "il": [
            "ac",
            "co",
            "org",
            "net",
            "k12",
            "gov",
            "muni",
            "idf"
        ],
        
        // Japan
        "jp": [
            "ac",
            "ad",
            "co",
            "ed",
            "go",
            "gr",
            "lg",
            "ne",
            "or"
        ],
        
        // Russia
        "ru": [
            // Generic
            "ac",
            "com",
            "edu",
            "gov",
            "int",
            "mil",
            "net",
            "org",
            "pp",
            // Federal subjects
            "adygeya",
            "bashkiria",
            "buryatia",
            "ulan-ude",
            "grozny",
            "cap",
            "dagestan",
            "nalchik",
            "kalmykia",
            "kchr",
            "karelia",
            "ptz",
            "khakassia",
            "komi",
            "mari-el",
            "mari",
            "joshkar-ola",
            "mordovia",
            "yakutia",
            "vladikavkaz",
            "kazan",
            "tatarstan",
            "tuva",
            "izhevsk",
            "udmurtia",
            "udm",
            "altai",
            "kamchatka",
            "khabarovsk",
            "khv",
            "kuban",
            "krasnoyarsk",
            "perm",
            "marine",
            "vladivostok",
            "stavropol",
            "stv",
            "chita",
            "amur",
            "arkhangelsk",
            "astrakhan",
            "belgorod",
            "bryansk",
            "chelyabinsk",
            "chel",
            "ivanovo",
            "irkutsk",
            "koenig",
            "kaluga",
            "kemerovo",
            "kirov",
            "vyatka",
            "kostroma",
            "kurgan",
            "kursk",
            "lipetsk",
            "magadan",
            "mosreg",
            "murmansk",
            "nnov",
            "nov",
            "novosibirsk",
            "nsk",
            "omsk",
            "orenburg",
            "oryol",
            "penza",
            "pskov",
            "rnd",
            "ryazan",
            "samara",
            "saratov",
            "sakhalin",
            "yuzhno-sakhalinsk",
            "e-burg",
            "yekaterinburg",
            "smolensk",
            "tambov",
            "tver",
            "tomsk",
            "tom",
            "tsk",
            "tula",
            "tyumen",
            "simbirsk",
            "vladimir",
            "volgograd",
            "tsaritsyn",
            "vologda",
            "cbg",
            "voronezh",
            "vrn",
            "yaroslavl",
            "mos",
            "msk",
            "spb",
            "bir",
            "jar",
            "chukotka",
            "surgut",
            "yamal",
            // Other geographic
            "amursk",
            "baikal",
            "cmw",
            "fareast",
            "jamal",
            "kms",
            "k-urals",
            "kustanai",
            "kuzbass",
            "magnitka",
            "mytis",
            "nakhodka",
            "nkz",
            "norilsk",
            "snz",
            "oskol",
            "pyatigorsk",
            "rubtsovsk",
            "syzran",
            "tlt",
            "vdonsk",
            // Test domain
            "test"
        ],
        
        // South Africa
        "za": [
            // Approved
            "ac",
            "co",
            "edu",
            "gov",
            "law",
            "mil",
            "net",
            "nom",
            "org",
            "school",
            "web",
            // Dormant
            "alt",
            "ngo",
            "tm",
            // Private
            "agric",
            "grondar",
            "nis"
        ],
        
        // South Korea
        "kr": [
            // General
            "co",
            "ne",
            "or",
            "re",
            "pe",
            "go",
            "mil",
            "ac",
            "hs",
            "ms",
            "es",
            "sc",
            "kg",
            "seoul",
            "busan",
            "daegu",
            "incheon",
            "gwangju",
            "daejeon",
            "ulsan",
            "gyeonggi",
            "gangwon",
            "chungbuk",
            "chungnam",
            "jeonbuk",
            "jeonnam",
            "gyeongbuk",
            "gyeongnam",
            "jeju",
            "한글",
            // Defunct
            "pusan",
            "taegu",
            "inchon",
            "kwangju",
            "taejon",
            "kyonggi",
            "kangwon",
            "chonbuk",
            "chonnam",
            "kyongbuk",
            "kyongnam",
            "cheju",
            "nm"
        ],
        
        // Spain
        "es": [
            "com",
            "nom",
            "org",
            "gob",
            "edu"
        ],
        
        // Sri Lanka
        "lk": [
            // Restricted
            "gov",
            "ac",
            "sch",
            "net",
            "int",
            // Open registration
            "com",
            "org",
            "edu",
            "ngo",
            "soc",
            "web",
            "ltd",
            "assn",
            "grp",
            "hotel"
        ],
        
        // Thailand
        "th": [
            "ac",
            "co",
            "go",
            "mi",
            "or",
            "net",
            "in"
        ],
        
        // Trinidad and Tobago
        "tt": [
            "co",
            "com",
            "org",
            "net",
            "travel",
            "museum",
            "aero",
            "tel",
            "name",
            "charity",
            "mil",
            "edu",
            "gov"
        ],
        
        // Türkiye
        "tr": [
            "gov",
            "mil",
            "tsk",
            "k12",
            "edu",
            "av",
            "dr",
            "bel",
            "pol",
            "kep",
            "com",
            "net",
            "org",
            "info",
            "bbs",
            "nom",
            "tv",
            "biz",
            "tel",
            "gen",
            "web",
            "name"
        ],
        
        // Ukraine
        "ua": [
            // Generic
            "com",
            "in",
            "org",
            "net",
            // Special
            "edu",
            "gov",
            "mil",
            "dod",
            // Geographical, containing numerous mirror domains
            "cherkasy",
            "cherkassy",
            "ck",
            "chernihiv",
            "chernigov",
            "cn",
            "chernivtsi",
            "chernovtsy",
            "cv",
            "crimea",
            "sebastopol",
            "yalta",
            "dnipropetrovsk",
            "dnepropetrovsk",
            "dp",
            "donetsk",
            "dn",
            "ivano-frankivsk",
            "if",
            "kharkiv",
            "kharkov",
            "kh",
            "kherson",
            "ks",
            "khmelnytskyi",
            "khmelnitskiy",
            "km",
            "kropyvnytskyi",
            "kirovograd",
            "kr",
            "kyiv",
            "kiev",
            "lugansk",
            "lg",
            "lutsk",
            "volyn",
            "lt",
            "lviv",
            "mykolaiv",
            "nikolaev",
            "mk",
            "odesa",
            "odessa",
            "od",
            "poltava",
            "pl",
            "rivne",
            "rovno",
            "rv",
            "sumy",
            "sm",
            "ternopil",
            "te",
            "uzhhorod",
            "uzhgorod",
            "uz",
            "zakarpattia",
            "vinnytsia",
            "vinnica",
            "vn",
            "zaporizhzhia",
            "zaporizhzhe",
            "zp",
            "zhytomyr",
            "zhitomir",
            "zt",
            // Geographical (terminated)
            "chernovtsy",
            "chernigov",
            "dnepropetrovsk",
            "dnipropetrovsk",
            "kirovograd",
            "khmelnitskiy",
            "rovno",
            // Reserved
            "cr",
            "krym",
            "kv",
            "lv",
            "sb",
            "sevastopol",
            "sicheslav",
            // Technological
            "admin",
            "ipv6",
            "ns",
            "ua",
            "www",
            "xn--mqa",
            "dnssec",
            "rdap",
            "epp1",
            "epp2"
        ],
        
        // United Kingdom
        "uk": [
            // Active
            "ac",
            "bl",
            "co",
            "gov",
            "judiciary",
            "ltd",
            "me",
            "mod",
            "net",
            "nhs",
            "nic",
            "org",
            "parliament",
            "plc",
            "police",
            "rct",
            "royal",
            "sch",
            "ukaea",
            // Inactive
            "govt",
            "orgn",
            "lea",
            "mil"
        ],
        
        // United States
        "us": [
            "fed",
            "isa",
            "nsn",
            "dni",
            "kids",
            // 50 States + DC
            "al",
            "ak",
            "az",
            "ar",
            "ca",
            "co",
            "ct",
            "de",
            "dc",
            "fl",
            "ga",
            "hi",
            "id",
            "il",
            "in",
            "ia",
            "ks",
            "ky",
            "la",
            "me",
            "md",
            "ma",
            "mi",
            "mn",
            "ms",
            "mo",
            "mt",
            "ne",
            "nv",
            "nh",
            "nj",
            "nm",
            "ny",
            "nc",
            "nd",
            "oh",
            "ok",
            "or",
            "pa",
            "ri",
            "sc",
            "sd",
            "tn",
            "tx",
            "ut",
            "vt",
            "va",
            "wa",
            "wv",
            "wi",
            "wy",
            // Territories
            "as",
            "gu",
            "mp",
            "pr",
            "vi"
        ]
    ]
    
    /// Returns the number of trailing components that make up the domain extension.
    ///
    /// Note that it is rare to have more than two components be considered part of the domain extension.
    static func extensionComponentCount(inDomainComponents components: [String]) -> Int {
        guard components.count > 1 else { return 0 }
        guard components.count > 2 else { return 1 }
        
        let tld = components[components.endIndex(offsetBy: -1)] // top-level
        let sld = components[components.endIndex(offsetBy: -2)] // second-level
        
        if let slds = twoLevelDomainExtensions[tld],
           slds.contains(sld)
        {
            return 2
        } else {
            // assume a single top-level domain extension
            return 1
        }
    }
}
