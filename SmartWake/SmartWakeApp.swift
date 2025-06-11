import SwiftUI
import UserNotifications

@main
struct SmartWakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showChallenge = false    // Controls navigation to quiz screen

    var body: some Scene {
        WindowGroup {
            if showChallenge {
                MultiplyChallengeView()
            } else {
                ContentView()
                    .onAppear {
                        // Ask for alert + sound permission (minimum required)
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                            if success {
                                print("Notification authorization granted ✅")
                            } else if let error = error {
                                print("Authorization error: \(error.localizedDescription)")
                            }
                        }
                        // Listen for taps on the banner
                        NotificationCenter.default.addObserver(forName: Notification.Name("notificationTapped"),
                                                               object: nil,
                                                               queue: .main) { _ in
                            showChallenge = true
                        }
                    }
            }
        }
    }
}
