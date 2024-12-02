import SwiftUI

// MARK: - ToDoItemView
struct ToDoItemView: View {
    var item: ToDoItem
    let onCircleTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            background
            HStack(alignment: .top) {
                doneIndicator
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
extension ToDoItemView {
    private var doneIndicator: some View {
        (item.isDone == true ? Images.circleDone.swiftUIImage : Images.circleToDo.swiftUIImage)
            .resizable()
            .frame(width: 24, height: 24)
            .onTapGesture {
                onCircleTap()
            }
    }
    
    private var title: some View {
        Text(item.title)
            .padding(.bottom, 6)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(item.isDone ? .customStroke : .customWhite)
            .strikethrough(item.isDone)
    }
    
    private var description: some View {
        Text(item.itemDescription)
            .padding(.bottom, 6)
            .lineLimit(2)
            .foregroundStyle(item.isDone ? .customStroke : .customWhite)
            .font(.system(size: 12))
    }
    
    private var date: some View {
        Text(item.creationDate.slashFormatted(date: .numeric, time: .omitted))
            .foregroundStyle(.customStroke)
            .font(.system(size: 12))
    }
    
    private var background: some View {
        Colors.customBlack.swiftUIColor
            .ignoresSafeArea()
    }
}

// MARK: - Preview
#Preview {
    ToDoItemView(
        item: ToDoItem(
            isDone: false,
            title: "Название задачи",
            itemDescription: "Описание задачи",
            creationDate: .now
        ), onCircleTap: {}
    )
}
