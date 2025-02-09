import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Dialog {
    //signal onClosed()

    property int type

    AppBar {
        id: appBar
        headerText: if(type == 1) {
                        "Ваши расходы"
                    } else {
                        "Ваши доходы"
                    }

        AppBarSpacer {}

        AppBarButton {
            text: if(type == 1) {
                      "Добавить траты"
                  } else {
                      "Добавить доход"
                  }

            icon.source: "image://theme/icon-m-add"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl("AddBudgetOperationDialog.qml"), { "type": type })
                dialog.accepted.connect(function() {
                    addBudgetItemToDB(dialog)
                })
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

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        font.family: Theme.fontFamilyHeading
                        text: if(model.title) {
                                  model.title
                              } else ""
                    }

                    Label {
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
        }

        Component.onCompleted: {
            loadBudgetItems()
        }
    }

    function addBudgetItemToDB(dialog) {
        var formatedValue = parseFloat(dialog.value.replace(",", "."))
        var itemId = DB.insertBudgetItem(dialog.categoryName, formatedValue, dialog.comment, dialog.groupId, dialog.type)
        DB.getBudgetItem(itemId, function (item) {
            console.log(item.title)
            listModel.insert(0, createBudgetItemJson(item))
        })
    }

    function loadBudgetItems() {
        DB.getAllBudgetItemsByCategoryType(type, function(rows){
            for (var i = 0; i < rows.length; i++) {
                var item = rows.item(i)
                listModel.append(createBudgetItemJson(item))
            }
        })
    }

    function createBudgetItemJson(item) {
        return {
            "title": item.title,
            "value": item.value,
            "comment": item.comment,
        }
    }
}
