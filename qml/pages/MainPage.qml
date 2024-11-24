import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtQuick.LocalStorage 2.0
import "../assets/AppDatabase.js" as DB

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    //    AppBar {
    //        AppBarSpacer {}

    //        AppBarButton {
    //            context: "Доходы"
    //            text: "Доходы"
    //            icon.source: "image://theme/icon-m-print"
    //        }
    //        AppBarSpacer {}

    //        AppBarButton {
    //            context: "Расходы"
    //            text: "Расходы"
    //            icon.source: "image://theme/icon-m-print"
    //        }
    //        AppBarSpacer {}
    //    }

    SilicaListView {
        id: silicaListView
        header: PageHeader {
            objectName: "pageHeader"
            title: qsTr("Money Spent")
        }
        quickScroll: true
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Категории"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
                }
            }

            MenuItem {
                text: "Добавить доход"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("IncomesPage.qml"))
                }
            }

            MenuItem {
                text: "Добавить расходы"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ExpensesPage.qml"))
                }
            }
        }

        Component.onCompleted: {
            DB.initDatabase()
        }
    }
}
