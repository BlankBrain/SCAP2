//
//  ChatVC.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import CryptoKit
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var TxtMessage: UITextField!
    let refreshControl = UIRefreshControl()
    let firebaseAuth = Auth.auth()
    var documents: [DocumentSnapshot] = []
    var messages: [Message] = []
    var DocID = [String]()
    var lastMessageId: String = ""
    let db = Firestore.firestore()
    let senderID = preferenceHelper.getUserId()
    var hashString = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        addRightBarButtonItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "cell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        getMessages(Room: "messages")
        
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let newMessage = TxtMessage.text else { return
            Utility.showPopup(with: "empty message", on: self)
        }
        sendMessage(text: newMessage)
        
    }
    
    func getMessages(Room: String) {
        
        let data = "Hello, world!".data(using: .utf8)!
        self.hashString = generateHashString(data: data)
        
        db.collection(Room).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                
                return
            }
            
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    self.documents.append(document)
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            //self.documents = documents
            self.DocID.removeAll()
            
            let unsortedMessages = self.messages
            self.messages = unsortedMessages.sorted(by: { $0.timestamp < $1.timestamp })
            
            for document in documents.sorted(by:  { (doc1, doc2) -> Bool in
                let timestamp1 = doc1.data()["timestamp"] as? TimeInterval ?? 0.0
                let timestamp2 = doc2.data()["timestamp"] as? TimeInterval ?? 0.0
                return timestamp1 < timestamp2 // Sort in descending order
            }) {
                // Process each document here
                let data = document.data()
                print( "DocumentID: \(document.documentID)")
                self.documents.append(document)
                self.DocID.append(document.documentID)
                
            }
            
            self.tableView.reloadData()
        }
    }
    
    func sendMessage(text: String) {
        do {
            let newMessage = Message(id: self.hashString , sender: senderID , text: text, received: false, timestamp: Date())
            
            try db.collection("messages").document().setData(from: newMessage)
            self.TxtMessage.text = ""
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
    func updateMessage(messageID: String, newText: String, newID: String) {
        
        let messageRef = db.collection("messages").document(messageID)
        messageRef.updateData([
            "text": newText,
            "id": newID,
        ]) { error in
            if let error = error {
                print("Error updating message in Firestore: \(error)")
            } else {
                print("Message updated successfully!")
                self.getMessages(Room: "messages")
                self.tableView.reloadData()
            }
        }
        
    }
    func DeleteMessage(messageID: String, Index: String) {
        
        let documentRef = db.collection("messages").document(messageID)
        print(" \(db.collection("messages").document(messageID))  Deleted" )
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully!")
            }
        }
    }
    func addRightBarButtonItems() {
        let button1 = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(button1Tapped))
        let button2 = UIBarButtonItem(title: "Join Chat", style: .plain, target: self, action: #selector(button2Tapped))
        
        navigationItem.rightBarButtonItems = [button1, button2]
    }
    
    @objc func button1Tapped() {
        // Handle button 1 tap here
        print("1")
        self.performSegue(withIdentifier: SEGUE.CHAT_TO_PROFILE, sender: self)
    }
    
    @objc func button2Tapped() {
        // Handle button 2 tap here
        print("2")
        captureImage()
        
    }
    
    @objc private func refreshTableView() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //MARK: Camera code
    func captureImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true, completion: nil)
    }
    
    func readQRCode(from image: UIImage) -> String? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: ciImage)
        if let feature = features?.first as? CIQRCodeFeature {
            return feature.messageString
        }
        return nil
    }
    
    
}
extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cell
        let selectedDocument = self.documents[indexPath.row]
        let message = self.messages[indexPath.row]
        
        
        cell.message.text = message.text
        let time = message.timestamp.formatted(.dateTime.month().day().hour().minute())
        cell.status.text = "sent at \(time) by \(message.sender)"
        //tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive , title: "") { [self] (action, view, completion) in
            completion(true)
        }
        
        swipeAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        tableView.reloadData()
        return configuration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.documents[indexPath.row]
        
        print("Selected item: \(selectedItem)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("############")
        let message = self.messages[indexPath.row]
        print(message.text)
        print(self.DocID[indexPath.row])
        
        
        
        
        updateMessage(messageID: selectedItem.documentID , newText: generatePoop(), newID: generatePoop())
        // DeleteMessage(messageID: selectedItem.documentID, Index: "\(indexPath.row)")
        
    }
    func generatePoop() -> String{
        let rnd = Utility.generateRandomText(length: 23)
        let poop = Utility.shuffleString(input: rnd)
        return poop
        
    }
    
    func generateHashString(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        return String(hashString.prefix(64))
    }
}
extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            // Do something with the captured image
            
            if let qrCodeText = readQRCode(from: image) {
                print("QR code text: \(qrCodeText)")
                Common.shared.qrCodeText = qrCodeText
                self.messages.removeAll()
                getMessages(Room: qrCodeText)
            } else {
                print("No QR code found in the image.")
            }
            
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
