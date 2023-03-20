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

class ChatVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var TxtMessage: UITextField!
    let refreshControl = UIRefreshControl()
   // let firebaseAuth = Auth.auth()
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
        
        getMessages(Room: Common.shared.currentRoom)
        
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
            
//            for document in documents.sorted(by:  { (doc1, doc2) -> Bool in
//                let timestamp1 = doc1.data()["timestamp"] as? TimeInterval ?? 0.0
//                let timestamp2 = doc2.data()["timestamp"] as? TimeInterval ?? 0.0
//                return timestamp1 < timestamp2 // Sort in descending order
//            }) {
//                // Process each document here
//                let data = document.data()
//                print( "DocumentID: \(document.documentID)")
//                self.documents.append(document)
//                self.DocID.append(document.documentID)
//                
//            }
            
            self.tableView.reloadData()
        }
    }
    func getDocumentID(forMessageText messageText: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection(Common.shared.currentRoom)
            .whereField("text", isEqualTo: messageText)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(.failure(error))
                } else {
                    for document in querySnapshot!.documents {
                        let documentID = document.documentID
                        Common.shared.DocumentID = documentID
                        print("\(documentID) => \(document.data())")
                        completion(.success(documentID))
                        return
                    }
                    
                    // If no documents were found, return an error
                    completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                }
            }
    }



    func sendMessage(text: String) {
        do {
            let newMessage = Message(id: self.hashString , sender: senderID , text: text, received: false, timestamp: Date())
            
            try db.collection(Common.shared.currentRoom).document().setData(from: newMessage)
            self.TxtMessage.text = ""
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
    func updateMessage(id: String, newText: String, newID: String) {
        guard !id.isEmpty else {
            print("Error: Document ID is empty")
            return
        }
        
        let messageRef = db.collection(Common.shared.currentRoom).document(id)
        let userid = preferenceHelper.getUserId
        if(Common.shared.CurrentMessage.sender == userid() ) {
            
        messageRef.updateData([
            "text": newText,
            "id": newID,
        ]) { error in
            if let error = error {
                print("Error updating message in Firestore: \(error)")
            } else {
                print("Message updated successfully!")
                self.getMessages(Room: Common.shared.currentRoom)
                self.tableView.reloadData()
            }
        }
        }else{
            Utility.showPopup(with: "You Can not Hide Other People's Message", on: self)
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
     
        self.performSegue(withIdentifier: SEGUE.CHAT_TO_PROFILE, sender: self)
    }
    
    @objc func button2Tapped() {
        // Handle button 2 tap here
      
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
        
        if indexPath.row < self.messages.count {
            let message = self.messages[indexPath.row]
            cell.message.text = message.text
            let time = message.timestamp.formatted(.dateTime.month().day().hour().minute())
            cell.status.text = "sent at \(time) by \(message.sender)"
        } else {
            cell.message.text = ""
            cell.status.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: "Hide") { [self] (action, view, completion) in
            print("hello")
            completion(true)
        }
        
        swipeAction.backgroundColor = .red
      

        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        Common.shared.CurrentMessage = message
        if indexPath.row < self.messages.count {
            
            print(message.text)
            
            if indexPath.row < self.DocID.count {
                let documentID = message.id//self.DocID[indexPath.row]
                
            } else {
                print("Error: No document ID \(message.id) found for row \(indexPath.row)")
            }
        } else {
            print("Error: Invalid row \(indexPath.row) selected")
        }
        print(message.id)
        //updateMessage(id: Common.shared.DocumentID, newText: generatePoop(), newID: generatePoop())
        getDocumentID(forMessageText: message.text) { result in
            switch result {
            case .success(let documentID):
                print("Document ID found: \(documentID)")
                // Do something with the document ID here
                self.updateMessage(id: documentID, newText: self.generatePoop(), newID: self.generatePoop())
            case .failure(let error):
                print("Error getting document ID: \(error.localizedDescription)")
                // Handle the error here
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
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
                Common.shared.currentRoom = qrCodeText
                self.messages.removeAll()
                getMessages(Room: qrCodeText)
                tableView.reloadData()
            } else {
                Utility.showPopup(with: "No QR code found in the image.", on: self)
                print("No QR code found in the image.")
            }
            
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

   

    
    
}

