import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Dialog {

    property int type

    property string categoryName
    property string value
    property string comment
    property int groupId

    onAccepted: {
        value = valueTextArea.text
        comment = commentTextArea.text
    }

    canAccept: valueTextArea.text.length > 0

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            DialogHeader {
                acceptText: "Добавить"
                cancelText: "Отменить"
                title: if(type) {
                           "Новый расход"
                       } else {
                           "Новый доход"
                       }
            }

            TextArea {
                id: valueTextArea
                placeholderText: "Сумма"

                label: "Сумма"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: commentTextArea.focus = true
            }

            TextArea {
                id: commentTextArea
                label: "Комментарий"
            }

            ComboBox {
                id: categoryComboBox
                label: "Категория"
                currentIndex: -1
                menu: ContextMenu {

                    Repeater {
                        model: ListModel {
                            id: listModel
                        }

                        MenuItem {
                            text: model.categoty_text
                            onClicked: {
                                categoryName = model.categoty_text
                                groupId = model.id
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    DB.getAllCategoriesByType(type, function(rows){
                        for (var i = 0; i < rows.length; i++) {
                            var category = rows.item(i)
                            listModel.append(createCategoryJson(category))
                        }
                    })
                }
            }
        }
    }

    function createCategoryJson(category) {
        return {
            "id": category.id,
            "categoty_text": category.category_name,
            "categoty_type": category.category_name,
            "section": category.type
        }
    }
}
