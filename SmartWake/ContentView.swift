import SwiftUI
import UserNotifications // Local-notification framework

struct ContentView: View {
    // Target time for the alarm; UI updates automatically on change
    @State private var selectedHour = 7
    @State private var selectedMinute = 0
    @State private var alarmSet = false   // Tracks whether an alarm is pending

    var body: some View {
        VStack(spacing: 30) {
            Text("⏰ Get Up!!!!!!")
                .font(.largeTitle)
                .bold()
            
            // Wheel picker—hour & minute only (no date)
            DatePicker("Pick a time", selection: bindingForTime(), displayedComponents: [.hourAndMinute])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

            Button(alarmSet ? "Cancel Alarm" : "Set Alarm") {
                if alarmSet {
                    cancelAlarm()
                } else {
                    scheduleAlarm()
                }
                alarmSet.toggle()
            }
            .padding()
            .background(alarmSet ? Color.red : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    /// Two-way binding that converts between the `DatePicker` value
    /// and the separate hour / minute `@State` properties.
    func bindingForTime() -> Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = selectedHour
                components.minute = selectedMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: {
                let components = Calendar.current.dateComponents([.hour, .minute], from: $0)
                selectedHour = components.hour ?? 0
                selectedMinute = components.minute ?? 0
            }
        )
    }
    
    /// Builds and registers a *one-time* local notification.
    func scheduleAlarm() {
        let content = UNMutableNotificationContent()
        content.title = "Wake Up!"
        content.body = "Time for the multiplication challenge 📚"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarmSound.caf"))
        content.categoryIdentifier = "alarmCategory"

        var dateComponents = DateComponents()
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: "wakeUpAlarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    /// Removes the pending request so memory isn’t wasted.
    func cancelAlarm() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["wakeUpAlarm"])
    }
}
#Preview {
    ContentView()
}
