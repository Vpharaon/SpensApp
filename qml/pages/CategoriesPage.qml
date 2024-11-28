import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Page {

    AppBar {
        id: appBar
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

    SilicaFlickable {
        anchors.fill: parent
        anchors.topMargin: appBar.height + Theme.paddingMedium + SafeZoneRect.insets.top

        SilicaListView {
            id: categoriesListView
            quickScroll: true
            model: ListModel { id: listModel }
            anchors.fill: parent
            delegate: ListItem {
                id: listItem

                contentHeight: Theme.itemSizeMedium
                ListView.onRemove: animateRemoval(listItem)

                Behavior on opacity {
                    FadeAnimator {}
                }

                Label {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    truncationMode: TruncationMode.Fade
                    font.capitalization: Font.Capitalize
                    text: model.categoty_text
                }

                function removeCategory() {
                    remorseDelete(function() {
                        var categoryId = model.id
                        listModel.remove(index)
                        DB.deleteCategory(categoryId)
                    }, 2000)
                }

                menu: Component {
                    ContextMenu {
                        MenuItem {
                            text: "Редактировать"
                            onClicked: {//updateNote()
                            }
                        }
                        MenuItem {
                            text: "Удалить"
                            onClicked: removeCategory()
                        }
                    }
                }
            }

            VerticalScrollDecorator { }

            Component.onCompleted: {
                DB.getAllCategories(function(rows){
                    for (var i = 0; i < rows.length; i++) {

                        var category = rows.item(i)

                        var categotyData = {
                            "id": category.id.toString(10),
                            "categoty_text": category.category_name,
                        }

                        listModel.append(categotyData)
                    }
                })
            }
        }
    }
}
