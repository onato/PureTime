import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
    @Namespace private var animation

    var body: some View {
        VStack {
            Image("Background")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.secondary)
                .scaledToFit()
                .frame(height: 180)
            if viewModel.isPlaying {
                Text(viewModel.formattedTime).timeStyle()
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.togglePlay()
                    }
                }) {
                    Text(" Stop ").buttonStyle()
                }
                .matchedGeometryEffect(id: "Button", in: animation)
            } else {
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
                    withAnimation(.spring()) {
                        viewModel.togglePlay()
                    }
                }) {
                    Text("Begin").buttonStyle()
                }
                .matchedGeometryEffect(id: "Button", in: animation)
            }
        }
    }
}

#Preview {
    ContentView()
}
