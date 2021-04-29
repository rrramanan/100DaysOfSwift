//
//  ViewController.swift
//  Project25
//
//  Created by R R on 15/02/21.
//
import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        title = "Selfie Share"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        //challenge
        let bb1 = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendText))
        let bb2 = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let bb3 = UIBarButtonItem(title: "🌐", style: .plain, target: self, action: #selector(list))
        navigationItem.rightBarButtonItems = [bb1,bb2,bb3]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    func startHosting(action: UIAlertAction){
        guard let mcSession = mcSession else {return}
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction){
        guard let mcSession = mcSession else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

         if let imageView = cell.viewWithTag(1000) as? UIImageView {
             imageView.image = images[indexPath.item]
         }
        
        return cell
        
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        print(images.count)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else {return}
        
        if mcSession.connectedPeers.count > 0{
            if let imageData = image.pngData(){
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch  {
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
        
    }
    
    @objc func showConnectionPrompt(){
        
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
 
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            alertNotConnected(info:peerID.displayName)  //challenge
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data){
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            
            //challenge
            if !String(decoding: data, as: UTF8.self).isEmpty{
                let ac = UIAlertController(title: "Incoming Signal", message: String(decoding: data, as: UTF8.self), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
        }
        
    }
    
    //challenge
    func alertNotConnected(info:String){
        let ac = UIAlertController(title: "Info", message: "Disconnedted from \(info)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //challenge
    @objc func sendText(){
        let ac = UIAlertController(title: "Signal 👋", message: "Enter your message", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else {return}
            if text.isEmpty{
                return
            }
            guard let mcSession = self?.mcSession else {return}

            if mcSession.connectedPeers.count > 0{
                do {
                    try mcSession.send(Data(text.utf8), toPeers: mcSession.connectedPeers, with: .reliable)
                } catch  {
                    let ac = UIAlertController(title: "Error sending message", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
            }else{
                let ac = UIAlertController(title: "Info", message: "No Active Connection", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
        }))
        ac.addAction(UIAlertAction(title: "Nah", style: .cancel))
        present(ac, animated: true)
    }
    
    //challenge
    @objc func list(){
        guard let mcSession = mcSession else {return}
       
        if mcSession.connectedPeers.count > 0{
            var device = [String]()
            for item in  mcSession.connectedPeers {
                device.append(item.displayName)
            }
         
            let ac = UIAlertController(title: "Active device", message: device.joined(separator: ","), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }else{
            let ac = UIAlertController(title: "Info", message: "No deivce connected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    
    }
    
    
}

