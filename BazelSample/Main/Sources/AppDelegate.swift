import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        //window?.rootViewController = makeRootViewController()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        printBundleProperties()
        return true
    }
    
    private func printBundleProperties() {
        let bundle = Bundle.main
        let bundleIdentifier = bundle.bundleIdentifier ?? "unknown bundle identifier"
        let appName = bundle.infoDictionary?["CFBundleName"] as? String ?? "unknown app name"
        let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let buildNumber = bundle.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        
        print("###############################################################")
        print("## \(appName) (\(bundleIdentifier))")
        print("###############################################################")
        print("## CFBundleShortVersionString: \(appVersion)")
        print("## CFBundleVersion: \(buildNumber)")
        print("###############################################################")
    }
}
