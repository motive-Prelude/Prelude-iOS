//
//  MainView.swift
//  Junction
//
//  Created by 송지혁 on 8/9/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some View {
        Button("테스트") {
            mainViewModel.sendMessageForQuiz("안녕 GPT야!")
        }
        
        Text(mainViewModel.receivedMessage ?? "안옴")
    }
}

#Preview {
    MainView()
}
