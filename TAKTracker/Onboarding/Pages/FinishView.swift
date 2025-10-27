//
//  FinishView.swift
//  TAKTracker
//
//  Created by Craig Clayton on 10/8/25.
//

import SwiftUI

struct FinishView: View {
    var body: some View {
        NavigationStack {
            List {
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        Text("Setup Complete!")
                            .font(.headline).fontWeight(.semibold)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                   
                    Text("""
        And we're all done! You can update these settings at any time by clicking on the gear/wheel icon from the main screen. You'll also find the support contact information there if you have any problems. Happy TAK'ing!
        """)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FinishView()
}
