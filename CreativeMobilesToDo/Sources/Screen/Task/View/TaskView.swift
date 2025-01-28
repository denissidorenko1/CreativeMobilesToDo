import SwiftUI

// MARK: - TaskView
struct TaskView: View {
    @StateObject var presenter: TaskPresenter
    @StateObject var router: TaskRouter

    @Environment(\.dismiss) private var dismiss

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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Сохранить") {
                    presenter.didTapSave()
                }
            })
        }
        .alert(
            LocalizedStringKey("Название или описание отсутствуют"),
            isPresented: $router.isShowingWarning,
            actions: {
            })
        .onChange(of: router.isClosing) {
            dismiss()
        }
    }
}

// MARK: - UI Elements
extension TaskView {
    private var title: some View {
        TextField(text: $presenter.title, prompt: Text("Введите название")
            .foregroundStyle(Colors.customWhite.swiftUIColor), axis: .horizontal, label: {})
            .foregroundStyle(Colors.customWhite.swiftUIColor)
            .font(.system(size: 34).bold())
            .padding(.bottom, 8)
    }

    private var date: some View {
        Text(presenter.creationDate.slashFormatted(date: .numeric, time: .omitted))
            .font(.system(size: 12))
            .foregroundStyle(Colors.customStroke.swiftUIColor)
            .padding(.bottom, 16)
    }

    private var description: some View {
        TextEditor(text: $presenter.description)
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
    TaskViewBuilder.build(with: nil)
}
