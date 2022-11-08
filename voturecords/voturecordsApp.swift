//
//  voturecordsApp.swift
//  voturecords
//
//  Created by Yannick Peysale on 07/09/2020.
//

import SwiftUI
import Swinject

@main
struct voturecordsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    static let container = Container()
    
    @State var selectedTab = 0
    
    init() {
        voturecordsApp.container.register(ImageDownloaderProtocol.self, factory: { _ in
            ImageDownloader()
        })
        
        voturecordsApp.container.register(NetworkCallHelper.self, factory: { _ in
            DefaultNetworkCallHelper()
        })
        
        voturecordsApp.container.register(APIHelper.self, factory: { resolver in
            guard let networkCallHelper = resolver.resolve(NetworkCallHelper.self) else {
                return DefaultAPIHelper(networkCallHelper: DefaultNetworkCallHelper())
            }
            return DefaultAPIHelper(networkCallHelper: networkCallHelper)
        })
        
        UITabBar.appearance().barTintColor = UIColor(Color.votuBackground)
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().isTranslucent = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if allowed {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                NewsView()
                    .tabItem {
                        Label("Latest news", systemImage: "list.dash")
                    }
                    .tag(0)
                ProductList()
                    .tabItem {
                        Label("Products", systemImage: "record.circle")
                    }
                    .tag(1)
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "info.circle")
                    }
                    .tag(2)
            }
            .accentColor(Color.votuTint)
        }
    }
}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    //No callback in simulator
    //-- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        guard let apiHelper = voturecordsApp.container.resolve(APIHelper.self) else {
            NSLog("Couldn't resolve apiHelper : specifying a default one")
            return
        }
        apiHelper.registerPushNotifications(with: token) { result in
            switch result {
            case .success :
                NSLog("Registration success")
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
