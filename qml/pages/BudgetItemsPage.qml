import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Page {

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
                        id: title
                        text: model.title
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
                    text: model.value
                }


                ViewPlaceholder {
                    enabled: silicaListView.count == 0
                    text: "Нет элементов"
                    hintText: "Воспользуйтесь меню, чтобы добавить"
                }

            }
        }

        Component.onCompleted: {
            loadBudgetItems()
        }
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
            "id": item.id.toString(10),
            "title": item.title,
            "value": item.value,
            "comment": item.comment,
            "category_id": item.category_id
        }
    }
}
