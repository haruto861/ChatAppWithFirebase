//
//  ChatInputAccesorryView.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/03/03.
//

import UIKit

// プロトコルとは
protocol ChatInputAccesorryViewDelegate: class {
    func tappedSendButton(text: String)
}

class ChatInputAccesorryView : UIView {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    // ChatRoomViewontrollerで呼び出す
    @IBAction func tappedSendButton(_ sender: Any) {
        guard let text = chatTextView.text else { return }
        delegate?.tappedSendButton(text: text)
        print("押された")
    }

    weak var delegate: ChatInputAccesorryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        setUpViews()
        //  テキストの量に合わせて可変にする
        autoresizingMask = .flexibleHeight
    }

    private func setUpViews() {
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = true

        chatTextView.text = ""
        chatTextView.delegate = self

    }
    func removeText() {
        chatTextView.text = ""
        sendButton.isEnabled = false
    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    private func nibInit() {
        let nib = UINib(nibName: "ChatInputAccesorryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatInputAccesorryView: UITextViewDelegate {
    // textviewがどのように変わっているのか確認
    func textViewDidChange(_ textView: UITextView) {
//        print("textView.text", textView.text)
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
