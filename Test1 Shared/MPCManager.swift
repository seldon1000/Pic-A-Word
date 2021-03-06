import MultipeerConnectivity

class MPCManager: NSObject {
    static public var sharedInstance = MPCManager()
    
    private let serviceType = "ADA-service"
    private var host = [MCPeerID]()
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCBrowserViewController
    private var session: MCSession
    
    private var isAdvertising_: Bool = false
    private var isBrowsing_: Bool = false
    private var connectedPeers = [MCPeerID]()
    
    var delegate: MPCManagerDelegate?
    
    private override init(){
        let additionalInfo : String = "\(UIDevice.current.systemName), \(UIDevice.current.systemVersion)"
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["SystemInfo" : additionalInfo], serviceType: serviceType)
        
        self.session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .optional)
        self.serviceBrowser = MCBrowserViewController(serviceType: serviceType, session: session)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        self.session.delegate = self
    }
    
    deinit {
        self.stopAdvertising()
        self.stopBrowsing()
    }
    
    public func startAdvertising() {
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    public func stopAdvertising() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    public func isAdvertising() -> Bool {
        return self.isAdvertising_
    }
    
    public func stopBrowsing() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    public func isBrowsing() -> Bool {
        return self.isBrowsing_
    }
    
    public func addConnectedPeer(peer: MCPeerID) {
        var changed : Bool = false
        if !(self.connectedPeers.contains(peer)) {
            self.connectedPeers.append(peer)
            changed = true
        }
        if changed {
            self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: self.getConnectedPeers())
            print("[DEBUG] Added a connected peer to the list")
        }
    }
    
    public func removeConnectedPeer(peer: MCPeerID) {
        var changed : Bool = false
        if self.connectedPeers.contains(peer) {
            self.connectedPeers = self.connectedPeers.filter{$0 != peer}
            changed = true
        }
        if changed {
            self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: getConnectedPeers())
            print("[DEBUG] Removed a peer from the list")
        }
    }
    
    public func getConnectedPeers() -> [MCPeerID] {
        return Array(self.connectedPeers)
    }
    
    public func sendData(text: String, peer: [MCPeerID]) {
        if let utfData = text.data(using: .utf8) {
            do {
                try self.session.send(utfData, toPeers: peer, with: .reliable)
            } catch {
                print("[DEBUG] [FAIL] \(error)")
            }
        }
    }
    
    public func getBrowser() -> MCBrowserViewController {
        return self.serviceBrowser
    }
}

extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("[DEBUG] [FAIL] didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("[DEBUG] didReceiveInvitationFromPeer: \(peerID)")
        
        if self.getConnectedPeers().count < 6 {
            invitationHandler(true, self.session)
        }
    }
}

extension MPCManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("[DEBUG] peer \(peerID) didChangeState: \(state.rawValue)")
        
        if state == MCSessionState.connected {
            print("[DEBUG] ******* Connected TO \(peerID)")
            self.addConnectedPeer(peer: peerID)
        } else if state == MCSessionState.notConnected {
            print("[DEBUG] ******* Disconnected from \(peerID)")
            self.removeConnectedPeer(peer: peerID)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message: String = String(data: data, encoding: .utf8)!
        print("[DEBUG] didReceiveData: \(message)")
        self.delegate?.receivedData(data: message, fromPeer: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("[DEBUG] didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("[DEBUG] didStartReceivingResourceWithName: \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("[DEBUG] didFinishReceivingResourceWithName: \(resourceName)")
    }
}

protocol MPCManagerDelegate {
    func connectedDevicesChanged(manager : MPCManager, connectedDevices: [MCPeerID])
    func receivedData(data: String, fromPeer: MCPeerID)
}

extension MPCManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        serviceBrowser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        serviceBrowser.dismiss(animated: true, completion: nil)
    }
}
