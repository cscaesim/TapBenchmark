//
//  ContentView.swift
//  Tap Benchmark
//
//  Created by Caine Simpson on 5/16/21.
//

import SwiftUI

enum TestCase {
    case beginning
    case wait
    case touch
    case end
}

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            self.viewModel.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Tap Benchmark")
                    .font(.title2)
                Divider()
                Spacer()
                Text("Your time:")
                    .font(.system(size: 32.0))
                    .fontWeight(.medium)
                Text("\(viewModel.reactionTime) ms")
                    .font(.system(size: 40.0))
                Spacer()
                Button(action: {
                    viewModel.buttonPressed()
//                    viewModel.setBackground(test: self.viewModel.test)
                }) {
                    Text("\(viewModel.buttonText)")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
//                .border(Color.black)
                .frame(width: 200, height: 200)
                .background(Color.white)
                .clipShape(Circle())
                Spacer()
            }
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        
        @Published var reactionTime: Int = 0
        @Published var test: TestCase = .end
        @Published var backgroundColor: Color
        @Published var buttonText = "Begin"
        
        var startTime = 0
        var tapTime = 0
        
        func setBackground(test: TestCase) -> Color {
            var color = Color.blue
            switch (test) {
            case .beginning:
                color = Color.red
            case .end:
                color = Color.blue
            case .wait:
                color = Color.yellow
            case .touch:
                color = Color.green
            }
            
            return color
        }
        
        func setButtonText(test: TestCase) -> String {
            var text = "Begin"
            switch (test) {
            case .beginning:
                text = "Starting"
            case .end:
                text = "Begin"
            case .wait:
                text = "Wait"
            case .touch:
                text = "Press!"
            }
            
            return text
        }
        
        init() {
            backgroundColor = Color.blue
            buttonText = setButtonText(test: test)
        }
        
        func startTest() {
            test = .wait
            self.backgroundColor = setBackground(test: test)
            buttonText = setButtonText(test: test)
            let seconds = randomStart()
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.startTime = self.getStartTime()
                self.test = .touch
                self.pressInterval()
            }
        }
        
        func getStartTime() -> Int {
            return Date().millisecondsSince1970
        }
        
        func buttonPressed() {
            if test == .end {
                startTest()
            } else if test == .beginning {
                print("Too fast!")
            } else if test == .touch {
                endTest()
            } else if test == .wait {
                print("too soon!")
            }
        }
        
        func endTest() {
            tapTime = Date().millisecondsSince1970
            test = .end
            backgroundColor = setBackground(test: test)
            buttonText = setButtonText(test: test)
            calculateResults(startTime: startTime, endTime: tapTime)
        }
        
        func calculateResults(startTime: Int, endTime: Int) {
            self.reactionTime = endTime - startTime
        }
        
        func pressInterval() {
            test = .touch
            self.backgroundColor = setBackground(test: test)
            buttonText = setButtonText(test: test)
        }
        
        func randomStart() -> Double {
            return Double.random(in: 1...8)
        }
        
//        func change
        
        func getTime() {
            let time = Date().millisecondsSince1970
            reactionTime = time
            print(time)
        }
    }
}

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
