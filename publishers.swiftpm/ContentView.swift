import SwiftUI
import Combine

struct ContentView: View {
    @State var count: Int = 0
    @State var cancellable: AnyCancellable? = nil
    // Mark this as State property otherwise
    // when modifing it in startTimer will throw error, as this is struct and modifying its property is not possible

    var body: some View {
        VStack {
            Text("\(count)")
            Button {
                self.startTimer()
            } label: {
                Text("Start")
            }

            Button {
                stopTimer()
            } label: {
                Text("Stop")
            }
                
        }
        .padding()
    }
    
    func startTimer() {
        self.cancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            // publisher that repeateldy emist the current date
            // every - time interval in seconds
            // on - thread
            // in - run mode
            .autoconnect()
            // automatically connects to upstream connectable pusblishers
            // here .publish will give Time.TimerPublisher which requires connect
            .scan(0, { count, out in
                return count+1
            })
            // Takes the previous val modifies it using clouser and return next value
            .sink(receiveCompletion: { _ in
                print("finished")
            }, receiveValue: { count in
                self.count = count
            })
            // recieve the published values
    }
    
    func stopTimer() {
        cancellable?.cancel()
        // way to cancel/stop subcription, other way is cancelable = nil
    }
}
