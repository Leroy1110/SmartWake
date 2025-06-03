import SwiftUI
import UserNotifications

@main
struct SmartWakeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showChallenge = false

    var body: some Scene {
        WindowGroup {
            if showChallenge {
                MultiplyChallengeView()
            } else {
                ContentView()
                    .onAppear {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                            if success {
                                print("הרשאה ניתנה ✅")
                            } else if let error = error {
                                print("שגיאה בהרשאה: \(error.localizedDescription)")
                            }
                        }
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
