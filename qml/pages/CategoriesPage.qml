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
            context: "Добавить категорию"
            text: "Добавить категорию"
            icon.source: "image://theme/icon-m-add"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("CategoryAddDialog.qml"))
                dialog.accepted.connect(function () {
                    var categoryId = DB.insertCategory(dialog.categoryName, dialog.type)

                    DB.getCategory(categoryId, function (category){
                        var model = createCategoryJson(category)
                        listModel.append(model)
                    })
                })
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        anchors.topMargin: appBar.height + Theme.paddingMedium + SafeZoneRect.insets.top

        SilicaListView {
            id: listView
            quickScroll: true
            model: ListModel { id: listModel }
            anchors.fill: parent

            delegate: ListItem {

                width: parent.width - 2 * x
                contentHeight: Theme.itemSizeMedium
                x: Theme.horizontalPageMargin

                Behavior on opacity {
                    FadeAnimator {}
                }

                Rectangle {
                    id: categoryColor
                    width: 30
                    height: 30
                    radius: 15
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: if(model.type === 0) {
                               "green"
                           } else if (model.type === 1){
                               "red"
                           } else {
                               "white"
                           }
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: categoryColor.right
                    truncationMode: TruncationMode.Fade
                    font.capitalization: Font.Capitalize
                    anchors.leftMargin: 50
                    text: model.categoty_text
                }

                function removeCategory() {
                    remorseDelete(function() {
                        var categoryId = model.id
                        listModel.remove(index)
                        DB.deleteCategory(categoryId)
                    }, 2000)
                }

                menu: ContextMenu {

                    hasContent: id > 11 // 11 так как добавлено 11 категорий по умолчанию

                    MenuItem {
                        text: "Редактировать"
                        onClicked: {

                        }
                    }

                    MenuItem {
                        text: "Удалить"
                        onClicked: removeCategory()
                    }
                }
            }

            VerticalScrollDecorator { }

            Component.onCompleted: {
                DB.getAllCategories(function(rows){
                    for (var i = 0; i < rows.length; i++) {
                        var category = rows.item(i)
                        var model = createCategoryJson(category)
                        listModel.append(model)
                    }
                })
            }
        }
    }

    function createCategoryJson(category) {
        return {
            "id": category.id.toString(10),
            "categoty_text": category.category_name,
            "type": category.type,
        }
    }
}
