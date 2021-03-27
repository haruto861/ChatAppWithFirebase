//
//  ChatRoomTableViewCell.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/02/23.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    var messageText: String? {
        didSet {
            guard let text = messageText else { return }
            let width = estimateFrameForTextView(text: text).width + 20
            messageTextWithConstraint.constant = width
            messageTextView.text = text
        }
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var userImageview: UIImageView!

    @IBOutlet weak var messageTextWithConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        self.backgroundColor = .clear
        userImageview.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius =  15
    }
    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    // テキストの幅の分だけテキストフィールドの長さを調整
    private func estimateFrameForTextView(text : String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}
