import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var selectedHour = 7
    @State private var selectedMinute = 0
    @State private var alarmSet = false

    var body: some View {
        VStack(spacing: 30) {
            Text("⏰ Get Up!!!!!!")
                .font(.largeTitle)
                .bold()

            DatePicker("בחר שעה", selection: bindingForTime(), displayedComponents: [.hourAndMinute])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

            Button(alarmSet ? "בטל שעון" : "הפעל שעון") {
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

    func scheduleAlarm() {
        let content = UNMutableNotificationContent()
        content.title = "קום כבר!"
        content.body = "הגיע הזמן לפתור את לוח הכפל 📚"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarmSound.caf"))
        content.categoryIdentifier = "alarmCategory"

        var dateComponents = DateComponents()
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: "wakeUpAlarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAlarm() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["wakeUpAlarm"])
    }
}
#Preview {
    ContentView()
}
