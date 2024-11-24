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
                        var noteData = {
                            "id": note.id.toString(10),
                            "date_text": note.date,
                            "time_text": note.time,
                            "note_text": note.note_text
                        }
                        listModel.insert(0, noteData)
                    }
                    )
                })
            }
        }
    }

    SilicaListView {
        id: categoriesListView

    }
}
