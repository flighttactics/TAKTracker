//
//  ChatVieww.swift
//  TAKTracker
//
//  Created by Craig Clayton on 1/4/24.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ChatViewModel()
    @State private var message = ""
    @State private var searchResults = ""
    @State private var searchText = ""
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geo in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    MessageView(message: message, viewWidth: geo.size.width)
                                        .padding(.horizontal)
                                }
                                .frame(maxWidth: .infinity, alignment: message.isFromCurrentUser() ? .trailing : .leading)
                            }
                        }
                    }
                }
                
                if #available(iOS 16.0, *) {
                    HStack {
                        TextField("Message", text: $message, axis: .vertical)
                            .padding()
                        
                        Button(action: {
                            if !message.isEmpty {
                                viewModel.send(message)
                                clear()
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.baseChatButtonColor)
                        }
                    }
                    .foregroundStyle(.primary)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.baseStrokeColor, lineWidth: 2)
                    )
                    .padding(.horizontal)
                } else {
                    HStack {
                        TextField("Message", text: $message)
                            .padding(.trailing, 20)
                            .padding()
                        
                        Button(action: { 
                            if message.isNotEmpty {
                                viewModel.send(message)
                                clear()
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.baseChatButtonColor)
                        }
                    }
                    .foregroundStyle(.primary)
                    .padding(.leading, 5)
                    .padding(.trailing, 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.baseStrokeColor, lineWidth: 2)
                    )
                    .padding(.horizontal)
                }
            }
            .background(Color.baseChatBackground.ignoresSafeArea(edges: .all))
            .onAppear {
                viewModel.messages = ChatViewModel.data
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func clear() {
        message = ""
    }
}

#Preview {
    ChatView()
}



