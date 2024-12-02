import SwiftUI

// MARK: - TaskView
struct TaskView: View {
    @StateObject private var viewModel: TaskViewModel

    init(item: ToDoItem?) {
        let viewModel = TaskViewModel(item: item)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            background
            VStack(alignment: .leading) {
                title
                date
                description
            }
            .padding(.horizontal, 20)
        }
        .onDisappear(perform: {
            viewModel.saveItem()
        })
    }
}

// MARK: - UI Elements
extension TaskView {
    private var title: some View {
        TextField(text: $viewModel.title, prompt: Text("Введите название")
            .foregroundStyle(Colors.customWhite.swiftUIColor), axis: .horizontal, label: {})
            .foregroundStyle(Colors.customWhite.swiftUIColor)
            .font(.system(size: 34).bold())
            .padding(.bottom, 8)
    }

    private var date: some View {
        Text(viewModel.creationDate.slashFormatted(date: .numeric, time: .omitted))
            .font(.system(size: 12))
            .foregroundStyle(Colors.customStroke.swiftUIColor)
            .padding(.bottom, 16)
    }

    private var description: some View {
        TextEditor(text: $viewModel.description)
            .scrollContentBackground(.hidden)
            .foregroundStyle(Colors.customWhite.swiftUIColor)
            .background(Colors.customBlack.swiftUIColor)
            .font(.system(size: 16))
            .lineLimit(10)

    }

    private var background: some View {
        Colors.customBlack.swiftUIColor
            .ignoresSafeArea()
    }
}

// MARK: - Preview
#Preview {
    TaskView(item: nil)
}
