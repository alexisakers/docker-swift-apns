import Foundation

extension String {
    
    func withMutableCString(body: @escaping (UnsafeMutablePointer<Int8>) -> Void) {
        
        self.withCString {
            cString in
            let mutableCString = UnsafeMutablePointer<Int8>(mutating: cString)
            body(mutableCString)
        }
        
    }
    
}
