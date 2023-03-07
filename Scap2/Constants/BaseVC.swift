//
//  BaseVC.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import UIKit
import Firebase
import FirebaseAuth

class BaseVC: UIViewController {
    var timeInterval: TimeInterval = 0.0
    let firebaseAuth = Auth.auth()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        printE("\(self) \(#function)")
    }
    //MARK: view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
        //self.setupNetworkReachability()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: APPDELEGATE.reachability)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }

   //MARK: Func
//    func setupNetworkReachability()
//    {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: APPDELEGATE.reachability)
//    }
    
//    func addRightBarButton() {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
////        button.addTarget(target, action: #selector(buttonPressed(_:)), for: .touchUpInside)
//        let barButtonItem = UIBarButtonItem(customView: button)
//
//
//        self.navigationItem.rightBarButtonItem = barButtonItem
//    }
    func firebaseAuthentication(){
        if firebaseAuth.currentUser == nil{
            print("TOKEN = \(preferenceHelper.getAuthToken())")
            firebaseAuth.signIn(withCustomToken: preferenceHelper.getAuthToken()) { user, error in
                if error == nil{
                    print("Firebase authentication successfull...")
                }
                else{
                    print(error ?? "Error in firebase authentication")
                }
            }
        }
    }
    func logOutFirebaseAuth()
    {
            do{
                try firebaseAuth.signOut()
                print("Logout successfully from firebase authentication")
                preferenceHelper.setAuthToken("")
            }catch let signOutError as NSError {
                print("Error signing out in: %@", signOutError)
            }
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

