//
//  ChatListViewController.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/02/23.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {

    var users = [User]()

    @IBOutlet private weak var chatListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        chatListTableView.delegate = self
        chatListTableView.dataSource = self

        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = "トーク"
        // barの文字の色
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        self.present(signUpViewController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchUserInfoFromFirestore()
    }

     // firestoreからデータを取得
    private func fetchUserInfoFromFirestore() {

        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("user情報の取得に失敗しました")
                return
            }
            snapshot?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                self.users.append(user)
//                print("data", data)
            })
        }


    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomviewController = storyboard.instantiateViewController(identifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomviewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

}
class chatListTableViewCell: UITableViewCell {
    @IBOutlet private weak var userImageView: UIImageView!

    @IBOutlet private weak var latestMessageLabel: UILabel!
    @IBOutlet private weak var partnerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
    }
    override func setSelected(_ selected: Bool, animated: Bool) {

    }
}
