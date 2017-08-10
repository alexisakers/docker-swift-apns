import Foundation

///
/// Represents a version number.
///

struct Version {
    
    /// The major version.
    let major: UInt32
    
    /// The minor version.
    let minor: UInt32
    
    /// The patch version.
    let patch: UInt32
    
}

extension Version: Comparable {

    static func == (lhs: Version, rhs: Version) -> Bool {
        guard lhs.major == rhs.major else { return false }
        guard lhs.minor == rhs.minor else { return false }
        guard lhs.patch == rhs.patch else { return false }
        return true
    }
    
    static func < (lhs: Version, rhs: Version) -> Bool {
        guard lhs.major < rhs.major else { return false }
        guard lhs.minor < rhs.minor else { return false }
        guard lhs.patch < rhs.patch else { return false }
        return true
    }
    
}
