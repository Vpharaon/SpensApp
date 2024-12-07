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

                    DB.getCategory(categoryId, function(category){
                        listModel.insert(0, createCategoryJson(category))
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
            id: listView
            quickScroll: true
            model: ListModel {
                id: listModel
            }
            anchors.fill: parent

            delegate: ListItem {
                width: listView.width
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

            section {
                property: "type"
                delegate: SectionHeader {
//                    text: if (categoty_type == 0) "Категории доходов"
//                          else "Категории расходов"
                    text: "categoty_type"
                }
            }

            VerticalScrollDecorator { }

            Component.onCompleted: {
                DB.getAllCategories(function(rows){
                    for (var i = 0; i < rows.length; i++) {
                        var category = rows.item(i)
                        listModel.append(createCategoryJson(category))
                    }
                })
            }
        }
    }

    function createCategoryJson(category) {
        return {
            "id": category.id.toString(10),
            "categoty_text": category.category_name,
            "type": category.category_type,
        }
    }
}
