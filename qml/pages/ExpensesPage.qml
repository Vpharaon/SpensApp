import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0

Page {
    AppBar {
        headerText: "Ваши расходы"
        AppBarSpacer {}
        AppBarButton {
            context: "Расходы"
            text: "Добавить траты"
            icon.source: "image://theme/icon-m-add"
        }
    }
}
