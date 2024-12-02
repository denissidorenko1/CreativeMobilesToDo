import SwiftUI


// MARK: - ToDoListView
struct ToDoListView: View {
    // FIXME: - переделать на протокол
    @StateObject private var viewModel: ToDoListViewModel = ToDoListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.filteredItems, id: \.title) { item in
                    ToDoItemView(item: item, onCircleTap: {
                        viewModel.toggleStatus(for: item)
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
                .navigationDestination(isPresented: $viewModel.isToDoViewPresented) {
                    TaskView(item: viewModel.selectedTodoItem)
                }
                footer
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            viewModel.fetch()
        })
    }
    
}

// MARK: - UI Elements
extension ToDoListView {
    private func editMenuAction(item: ToDoItem) -> some View {
        Button(action: {
            viewModel.selectedTodoItem = item
            viewModel.isToDoViewPresented = true
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
            viewModel.deleteItem(item: item)
        }) {
            Label(
                title: { Text("Удалить") },
                icon: { Images.trash.swiftUIImage }
            )
        }
    }
    
    
    private var footer: some View {
        VStack {
            ZStack{
                Colors.customGray.swiftUIColor
                quantityView
                    .foregroundStyle(Colors.customWhite.swiftUIColor)
                    .font(.system(size: 11).weight(.regular))
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.isToDoViewPresented = true
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
        if (2...4).contains(viewModel.itemsShownCount) {
            Text("\(viewModel.itemsShownCount) Задачи")
        } else {
            Text("\(viewModel.itemsShownCount) Задач")
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
    ToDoListView()
}
