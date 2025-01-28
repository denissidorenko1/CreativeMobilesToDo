import SwiftUI

// MARK: - ToDoListView
struct ToDoListView: View {
    @StateObject var presenter: ToDoListPresenter
    @StateObject var router: ToDoListRouter

    var body: some View {
        NavigationStack {
            VStack {
                List(presenter.filteredItems, id: \.title) { item in
                    ToDoItemView(item: item, onCircleTap: {
                        presenter.didToggleStatus(for: item)
                    })
                    .contextMenu {
                        editMenuAction(item: item)
                        shareMenuAction(item: item)
                        deleteMenuAction(item: item)
                    } preview: {
                        preview(item: item)
                    }
                }
                .navigationTitle("Задачи")
                .navigationDestination(isPresented: $router.isToDoViewPresented) {
                    TaskViewBuilder.build(with: router.selectedTodoItem)
                }
                .animation(.easeInOut, value: presenter.filteredItems)
                footer
            }
        }
        .listStyle(.plain)
        .searchable(text: $presenter.searchText, placement: .navigationBarDrawer)
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            presenter.didAppear()
        })
    }

}

// MARK: - UI Elements
extension ToDoListView {
    private func editMenuAction(item: ToDoItem) -> some View {
        Button(action: {
            router.navigateToTaskScreen(for: item)
        }) {
            Label(
                title: { Text("Редактировать") },
                icon: { Images.editMenu.swiftUIImage }
            )
        }
    }

    private func shareMenuAction(item: ToDoItem) -> some View {
        ShareLink(
            item: item.title,
            message: Text(item.itemDescription)
        ) {
            Label(
                title: { Text("Поделиться") },
                icon: { Images.export.swiftUIImage }
            )
        }
    }

    private func deleteMenuAction(item: ToDoItem) -> some View {
        Button(role: .destructive, action: {
            presenter.didTapDelete(item: item)
        }) {
            Label(
                title: { Text("Удалить") },
                icon: { Images.trash.swiftUIImage }
            )
        }
    }

    var footer: some View {
        VStack {
            ZStack {
                Colors.customGray.swiftUIColor
                quantityView
                    .foregroundStyle(Colors.customWhite.swiftUIColor)
                    .font(.system(size: 11).weight(.regular))
                HStack {
                    Spacer()
                    Button(action: {
                        router.navigateToTaskScreen(for: nil)
                    }, label: {
                        Images.edit.swiftUIImage
                            .frame(width: 68, height: 68)
                    })
                }
            }
            .frame(height: 49)
            Colors.customGray.swiftUIColor
                .ignoresSafeArea()
                .frame(height: 0)
        }
    }

    var quantityView: some View {
        if (2...4).contains(presenter.itemsShownCount) {
            Text("\(presenter.itemsShownCount) Задачи")
        } else {
            Text("\(presenter.itemsShownCount) Задач")
        }
    }

    func preview(item: ToDoItem) -> some View {
        ToDoItemPreview(toDoItem: item)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Colors.customGray.swiftUIColor)
            .frame(width: 320, height: 106)
    }
}

// MARK: - Preview
#Preview {
    ToDoListViewBuilder.build()
}
