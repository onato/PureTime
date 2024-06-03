import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()
        
    var body: some View {
        if viewModel.isPlaying {
            Text(viewModel.formattedTime)
        } else {
            Button(action: {
                viewModel.togglePlay()
            }) {
                Text("Begin")
                    .font(.system(size: 60, weight: .ultraLight, design: .rounded))
            }
        }
    }
}

#Preview {
    ContentView()
}
