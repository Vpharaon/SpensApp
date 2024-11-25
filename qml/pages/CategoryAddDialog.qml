import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property string categoryName

    onAccepted: {
        categoryName = categoryTextArea.text
    }

    canAccept: categoryTextArea.text.length > 0
    //    onAcceptBlocked: {

    //    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width

            DialogHeader {
                acceptText: "Сохранить"
                cancelText: "Отменить"
            }

            TextArea {
                id: categoryTextArea
                placeholderText: "Название категории"
                label: "Название категории"
            }
        }
    }
}
