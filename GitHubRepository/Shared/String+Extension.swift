import UIKit

extension String {
  
  /// Creates an attributed string with a bold prefix and a normal value text.
  ///
  /// - Parameters:
  ///   - prefix: The prefix text to be bolded.
  /// - Returns: An `NSAttributedString` with the prefix in bold and the value in normal font.
  func formattedText(prefix: String) -> NSAttributedString {
    let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
    let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
    
    let attributedString = NSMutableAttributedString(string: "\(prefix): ", attributes: boldAttributes)
    attributedString.append(NSAttributedString(string: self, attributes: normalAttributes))
    
    return attributedString
  }
}
