import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    AppBar {
        id: appBar
        headerText: "Ваш бюджет"

        AppBarSpacer {}

        AppBarButton {
            context: "Добавить расход"
            icon.source: "image://theme/icon-l-remove"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("AddBudgetOperationDialog.qml"), {
                                                "type": 1
                                            })

                dialog.accepted.connect(function () {
                    addBudgetItemToDB(dialog)
                })
            }
        }

        AppBarButton {
            context: "Добавить доход"
            icon.source: "image://theme/icon-l-add"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("AddBudgetOperationDialog.qml"), {
                                                "type": 0
                                            })


                dialog.accepted.connect(function () {
                    addBudgetItemToDB(dialog)
                })
            }
        }

        AppBarButton {
            onClicked: mainPopup.open()
            icon.source: "image://theme/icon-m-menu"

            PopupMenu {
                id: mainPopup
                PopupMenuItem {
                    text: "Категории"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
                    }
                    hint: "Страница управления категориями"
                }

                PopupMenuItem {
                    text: "Посмотреть доходы"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("BudgetItemsPage.qml"), {
                                           "type": 0
                                       })
                    }
                    hint: "Страница для просмотра всех доходов"
                }

                PopupMenuItem {
                    text: "Посмотреть расходы"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("BudgetItemsPage.qml"), {
                                           "type": 1
                                       })
                    }
                    hint: "Страница для просмотра всех расходов"
                }
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        anchors.topMargin: appBar.height + Theme.paddingMedium + SafeZoneRect.insets.top

        SilicaListView {
            id: silicaListView
            quickScroll: true
            anchors.fill: parent

            model: ListModel {
                id: listModel
            }

            delegate: ListItem {

                width: parent.width - 2 * x
                contentHeight: Theme.itemSizeMedium
                x: Theme.horizontalPageMargin

                Rectangle {
                    id: categoryColor
                    width: 30
                    height: 30
                    radius: 15
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: if(model.category_type === 0) {
                               "green"
                           } else if (model.category_type === 1){
                               "red"
                           } else {
                               "white"
                           }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 50
                    anchors.left: categoryColor.right

                    Label {
                        id: title
                        text: if(model.title) {
                                  model.title
                              } else ""
                        font.family: Theme.fontFamilyHeading
                    }

                    Label {
                        id: comment
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        font.family: Theme.fontSizeExtraSmall
                        text: if(model.comment) {
                                  model.comment
                              } else ""
                    }
                }

                Label {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.value + " " + String.fromCharCode(8381)
                }

            }

            ViewPlaceholder {
                enabled: silicaListView.count == 0
                text: "Нет элементов"
                hintText: "Воспользуйтесь меню, чтобы добавить"
            }

            Component.onCompleted: {
                DB.initDatabase()
                getAllBudgetItems()
            }
        }
    }

    function getAllBudgetItems() {
        listModel.clear()
        var totalSum = 0
        DB.getAllBudgetItems(function(rows){
            for (var i = 0; i < rows.length; i++) {
                var item = rows.item(i)
                if (item.category_type === 0) {
                    totalSum += item.value
                } else if (item.category_type === 1) {
                    totalSum -= item.value
                }

                listModel.append(createBudgetItemJson(item))
            }
        })

        appBar.subHeaderText = totalSum.toFixed(2) + String.fromCharCode(8381)
    }

    function addBudgetItemToDB(dialog) {
        var formatedValue = parseFloat(dialog.value.replace(",", "."))
        var itemId = DB.insertBudgetItem(dialog.categoryName, formatedValue, dialog.comment, dialog.groupId, dialog.type)

        //        DB.getBudgetItem(itemId, function(item){
        //            listModel.insert(0, createBudgetItemJson(item))
        //        }
        //        )
        getAllBudgetItems()
    }

    function createBudgetItemJson(item) {
        return {
            "id": item.id.toString(10),
            "title": item.title,
            "value": item.value,
            "comment": item.comment,
            "category_id": item.category_id,
            "category_type": item.category_type,
        }
    }
}
