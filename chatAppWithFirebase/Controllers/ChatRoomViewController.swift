
//
//  ChatRoomViewController.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/02/23.
//

import UIKit

class ChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomTableView: UITableView!

    private var messages = [String]()

    private lazy var chatInputAccesorryView: ChatInputAccesorryView = {
        let view = ChatInputAccesorryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self

        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
    }

    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccesorryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

// delegateで値を渡してあげる
extension ChatRoomViewController: ChatInputAccesorryViewDelegate {

    func tappedSendButton(text: String) {
        messages.append(text)
//        chatInputAccesorryView.chatTextView.text = nil
        chatInputAccesorryView.removeText()
        chatRoomTableView.reloadData()
        print("text", text)
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 最低基準となる高さを設定する
        chatRoomTableView.estimatedRowHeight = 40
        // textviewの高さを優先して自動で返してくれる
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatRoomTableViewCell
//        cell.messageTextView.text = messages[indexPath.row]
        cell.messageText = messages[indexPath.row]

        
        return cell
    }


}
