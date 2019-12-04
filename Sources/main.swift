// Test if swift compiler is properly marking CryptoKit as weak linked.
// If you build and run this on macOS 10.14.6
//  you should get it to run fine because the if #available wraps the CryptoKit call.
// However, instead you get the following error when you run it:
//		dyld: Library not loaded: /System/Library/Frameworks/CryptoKit.framework/Versions/A/CryptoKit
//		  Referenced from: /Users/haikuty/Library/Developer/Xcode/DerivedData/testwlbug-bjpmfkkzugftcafvudqhiodflcfm/Build/Products/Debug/testwlbug
//		  Reason: image not found
//		Abort trap: 6


import CryptoKit
import Foundation

extension String {
	func stringHash() -> String {
		var s = self
		guard let data = self.data(using: .utf8) else { return s }

		// CryptoKit isn't available prior to 10.15
		// but the compiler is not weak linking it like it should
		// so have to comment this out for now and just use b64 :-(
		// Filed: FB7471728 against this.
		// See: https://forums.swift.org/t/weak-linking-of-frameworks-with-greater-deployment-targets/26017
		if #available(iOS 13, macOS 10.15, *) {
			let digest = Insecure.SHA1.hash(data: data)
			for byte in digest {
				s += String(format: "%02x", UInt8(byte))
			}
		} else {
			if let b64s = String(data: data.base64EncodedData(), encoding: .utf8)?.suffix(128) {
				s = String(b64s)
			}
		}
		return s
	}
}


var text = "Hello, World! What do you think? Will it work?"
print( text.stringHash() )
