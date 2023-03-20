//
//  ProfileVC.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreImage
import CoreImage.CIFilterBuiltins

class ProfileVC: BaseVC {
    
    
    @IBOutlet weak var TxtCharRoomName: UITextField!
    
    
    

    var hashString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButton()
        let hashString = generateRandomHashString(length: 64)
        self.hashString = hashString
        print(hashString)
    }
    

    func generateRandomHashString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            result += String(characters[characters.index(characters.startIndex, offsetBy: randomIndex)])
        }
        return result
    }

    @IBAction func CreateChatRoom(_ sender: Any) {
        createCollection(CharRomm: self.hashString)
        showQRCodeActionSheet(for: self.hashString)
        
        
    }
    
    @IBAction func JoinRoom(_ sender: Any) {
        Common.shared.currentRoom = TxtCharRoomName.text ?? "messages"
        self.performSegue(withIdentifier: SEGUE.PROFILE_TO_CHAT, sender: self)

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
        let newMessage = "hello"
        let senderID = "admin.scap.com"
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
    
    func generateQRCode(from string: String, completion: @escaping (UIImage?) -> Void) {
        // Create a CIFilter object for generating QR code
        let filter = CIFilter.qrCodeGenerator()
        
        // Set the input message for the QR code filter
        let data = string.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Get the output image from the filter
        guard let outputImage = filter.outputImage else {
            completion(nil)
            return
        }
        
        // Convert the CIImage to UIImage and return it
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        let qrCodeImage = UIImage(cgImage: cgImage)
        completion(qrCodeImage)
    }

    func shareQRCodeImage(_ image: UIImage) {
        // Create an activity view controller for sharing the image
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // Present the activity view controller
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(activityVC, animated: true, completion: nil)
        }
    }

    func saveQRCodeImage(_ image: UIImage) {
        // Save the image to the photo library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    func showQRCodeActionSheet(for string: String) {
        // Generate the QR code image for the string
        generateQRCode(from: string) { image in
            guard let qrCodeImage = image else { return }
            
            // Create an action sheet with options to save or share the image
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "Save to Photos", style: .default) { _ in
                self.saveQRCodeImage(qrCodeImage)
            }
            actionSheet.addAction(saveAction)
            
            let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
                self.shareQRCodeImage(qrCodeImage)
            }
            actionSheet.addAction(shareAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancelAction)
            
            // Present the action sheet
            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(actionSheet, animated: true, completion: nil)
            }
        }
    }


}
