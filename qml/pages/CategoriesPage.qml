import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Page {

    AppBar {
        headerText: "Категории"
        AppBarSpacer {}
        AppBarButton {
            context: "Доходы"
            text: "Добавить категорию"
            icon.source: "image://theme/icon-m-add"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("CategoryAddDialog.qml"))
                dialog.accepted.connect(function () {
                    var categoryId = DB.insertCategory(dialog.categoryName)
                    DB.getCategory(categoryId, function(category){
                        var categotyData = {
                            "id": category.id.toString(10),
                            "categoty_text": category.category_name,
                        }
                        listModel.insert(0, categotyData)
                    }
                    )
                })
            }
        }
    }

    SilicaListView {
        id: categoriesListView
        quickScroll: true
        model: ListModel { id: listModel }
        delegate: ListItem {
            id: listItem
            contentHeight: Theme.itemSizeMedium
            Label {
                id: notesLabel
                x: Theme.horizontalPageMargin
                text: model.categoty_text
            }
        }

        VerticalScrollDecorator { }

        Component.onCompleted: {

        }
    }
}
