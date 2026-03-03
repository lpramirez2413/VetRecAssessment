import Foundation

struct Sizing {
    /// small: 8 pts
    static var s: CGFloat = 8.0
    
    /// medium: 16 pts
    static var m: CGFloat = 16.0
    
    /// large: 32 pts
    static var l: CGFloat = 32.0
    
    /// x-large: 48 pts
    static var xl: CGFloat = 48.0
    
    /// xx-large: 64 pts
    static var xxl: CGFloat = 64.0
    
    /// custom scale using 8 pts as factor
    static func scale(_ scale: Double) -> CGFloat {
        s * scale
    }
}
