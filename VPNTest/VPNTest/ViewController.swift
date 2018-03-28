//
//  ViewController.swift
//  VPNTest
//
//  Created by junlongZhou on 2018/3/1.
//  Copyright © 2018年 Mr.Zhou. All rights reserved.
//

import UIKit
import NetworkExtension


class ViewController: UIViewController {

    var providerManager:NETunnelProviderManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else {
                // Handle an occured error
                return
            }

            self.providerManager = managers?.first ?? NETunnelProviderManager()

            self.createVPN()
        }
        
   
    }
  
 
    
    func createVPN() {


            // Assuming the app bundle contains a configuration file named 'client.ovpn' lets get its
            // Data representation
            guard
                let configurationFileURL = Bundle.main.url(forResource: "超级混拨01", withExtension: "ovpn"),
                let configurationFileContent = try? Data(contentsOf: configurationFileURL)
                else {
                    fatalError()
            }

            let tunnelProtocol = NETunnelProviderProtocol()

            // If the ovpn file doesn't contain server address you can use this property
            // to provide it. Or just set an empty string value because `serverAddress`
            // property must be set to a non-nil string in either case.
            tunnelProtocol.serverAddress = "super01.ipduoduo.cc"

            // The most important field which MUST be the bundle ID of our custom network
            // extension target.
            tunnelProtocol.providerBundleIdentifier = "com.zhoutest.VPNTest.PacketTunnel"

            // Use `providerConfiguration` to save content of the ovpn file.
            tunnelProtocol.providerConfiguration = ["ovpn": configurationFileContent]

            // Provide user credentials if needed. It is highly recommended to use
            // keychain to store a password.
            tunnelProtocol.username = "iostest"
            let password = "123"
            tunnelProtocol.passwordReference = password.data(using:.utf8) // A persistent keychain reference to an item containing the password

            // Finish configuration by assigning tunnel protocol to `protocolConfiguration`
            // property of `providerManager` and by setting description.
            self.providerManager?.protocolConfiguration = tunnelProtocol

            self.providerManager?.localizedDescription = "OpenVPN Client"

            self.providerManager?.isEnabled = true
            // Save configuration in the Network Extension preferences

            self.providerManager?.saveToPreferences(completionHandler: { (error) in
                if let error = error  {
                    // Handle an occured error
                    print(error);
                }
                //3.
                self.providerManager?.loadFromPreferences(completionHandler: { (error) in
                    guard error == nil else {
                        // Handle an occured error
                        return
                    }
                    do {
//                        try self.providerManager?.connection.startVPNTunnel()
                       try self.providerManager?.connection.startVPNTunnel(options: [:])


                    } catch {
                        // Handle an occured error
                    }
                })
            })



    }

    
     
}

