import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        if viewModel.isPlaying {
            Text(viewModel.formattedTime).timeStyle()
            Button(action: {
                viewModel.togglePlay()
            }) {
                Text("Stop").buttonStyle()
            }
        } else {
            Image("Background")
                .resizable()
                .opacity(0.4)
                .scaledToFit()
                .frame(height: 180)
            HStack {
                Text("Ring every").labelStyle()
                Picker("Numbers", selection: $viewModel.selectedNumber) {
                    ForEach(1 ..< 60) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                Text("minutes").labelStyle()
            }.padding(20)
            Button(action: {
                viewModel.togglePlay()
            }) {
                Text("Begin").buttonStyle()
            }
        }
    }
}

#Preview {
    ContentView()
}
