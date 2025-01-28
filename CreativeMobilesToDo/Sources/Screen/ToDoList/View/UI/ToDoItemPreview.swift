import SwiftUI

// MARK: - ToDoItemPreview
struct ToDoItemPreview: View {

    var toDoItem: ToDoItem

    var body: some View {
        ZStack(alignment: .leading) {
            background
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    title
                    description
                    date
                }
            }
        }
    }
}

// MARK: - UI Elements
extension ToDoItemPreview {
    private var background: some View {
        Colors.customGray.swiftUIColor
    }

    private var title: some View {
        Text(toDoItem.title)
            .padding(.bottom, 6)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(toDoItem.isDone ? .customStroke : .customWhite)
            .strikethrough(toDoItem.isDone)
    }

    private var description: some View {
        Text(toDoItem.itemDescription)
            .padding(.bottom, 6)
            .lineLimit(2)
            .foregroundStyle(toDoItem.isDone ? .customStroke : .customWhite)
            .font(.system(size: 12))
    }

    private var date: some View {
        Text(toDoItem.creationDate.slashFormatted(date: .numeric, time: .omitted))
            .foregroundStyle(.customStroke)
            .font(.system(size: 12))
    }
}

// MARK: - Preview
#Preview {
    ToDoItemPreview(
        toDoItem: ToDoItem(
            isDone: true,
            title: "Купить что-то",
            itemDescription: "Чего-то хочется сердцу, но не знаю что",
            creationDate: .now
        )
    )
}
