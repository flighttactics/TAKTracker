import SwiftUI

struct CapsuleListButton: View {
    let option: ConnectionOptions
    @Binding var selection: ConnectionOptions?
    var action: () -> Void = {}

    private var isSelected: Bool { selection == option }

    var body: some View {
        Button {
            selection = (selection == option) ? nil : option
            action()
        } label: {
            HStack(spacing: 10) {
                Text(option.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.5))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
