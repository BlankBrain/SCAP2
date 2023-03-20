//
//  ProfileVC.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButton()
    }
    

    func addRightBarButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "power"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    @objc func buttonPressed(_ sender: UIButton) {
        do{
            try firebaseAuth.signOut()
            print("Logout successfully from firebase authentication")
            preferenceHelper.setAuthToken("")
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }catch let signOutError as NSError {
            print("Error signing out in: %@", signOutError)
        }
    }
    
    
    func createCollection(CharRomm: String) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(CharRomm)
        guard let newMessage = TxtMessage.text else { return
            Utility.showPopup(with: "empty message", on: self)
        }
        collectionRef.addDocument(data: [
            "id": self.hashString ,
            "sender": senderID,
            "text": newMessage,
            "received": false,
            "timestamp" :  Date()
            
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(collectionRef.collectionID)")
            }
        }
    }


}
