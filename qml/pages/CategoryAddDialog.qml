import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property string categoryName
    property int type

    onAccepted: {
        categoryName = categoryTextArea.text
        type = expenseSwitch.checked
    }

    canAccept: categoryTextArea.text.length > 0

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            DialogHeader {
                acceptText: "Сохранить"
                cancelText: "Отменить"
                title: "Новая категория"
            }

            TextArea {
                id: categoryTextArea
                placeholderText: "Название категории"
                label: "Название категории"
            }

            SectionHeader {
                text: "Тип категории"
            }

            TextSwitch {
                id: incomeSwitch
                text: "Категория доходов"
                checked: true
                onCheckedChanged: {
                    expenseSwitch.checked = !checked
                }
            }

            TextSwitch {
                id: expenseSwitch
                text: "Категория расходов"
                onCheckedChanged: {
                    incomeSwitch.checked = !checked
                }
            }
        }
    }
}
