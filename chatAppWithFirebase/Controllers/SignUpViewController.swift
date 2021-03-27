//
//  SignUpViewController.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/03/12.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!

    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        registerButton.layer.cornerRadius = 15

        emailTextFiled.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self

        registerButton.isEnabled = true
        registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
    }

    @IBAction private func tappedProfileImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction private func tappedRegisterButton(_ sender: Any) {
        guard let image = profileImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }

        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)

        storageRef.putData(uploadImage, metadata: nil) { (matadata, err) in
            if let err = err {
                print("FireStoregeへの情報の保存に失敗しました。")
                return
            }
            print("FireStorageへの情報の保存に成功しました")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました")
                    return
                }
                // urlの画像の取得　→ firestoreへのデータ保存
                guard let urlString = url?.absoluteString else { return }
                print("urlString",urlString)
                self.createUserToFireStore(profileImageUrl: urlString)
            }
        }

    }

    private func createUserToFireStore(profileImageUrl: String) {
        guard let email = emailTextFiled.text else { return }
        guard let password = passwordTextField.text else { return }

        // ユーザー認証
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if  let err = err {
                print("認証情報の保存に失敗しました")
            } else {
                print("認証情報の保存に成功しました")
                guard let uid =  res?.user.uid else { return }
                guard let userName = self.userNameTextField.text else { return }
                let docData = [
                    "email": email,
                    "userName": userName,
                    "createdAt ": Timestamp(),
                    "profileImageUrl": profileImageUrl
                ] as [String : Any]

                Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                    if let err = err {
                        print("データベースへの保存に失敗しました")
                        return
                    }
                    print("firestoreへの情報の保存が成功しました")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }


    }
}
extension SignUpViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextFiled.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        let usernameIsEmpty = userNameTextField.text?.isEmpty ?? false

        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
        }


    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let oroginalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(oroginalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // 画像を枠内に丸く収める
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
