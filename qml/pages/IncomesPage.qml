import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0

Page {
    AppBar {
        headerText: "Ваши доходы"
        AppBarSpacer {}
        AppBarButton {
            context: "Доходы"
            text: "Добавить доход"
            icon.source: "image://theme/icon-m-add"
        }
    }
}
