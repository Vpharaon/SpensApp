TARGET = ru.farionik.moneyspent.MoneySpentApp

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/assets/AppDatabase.js \
    qml/pages/AddBudgetOperationDialog.qml \
    qml/pages/BudgetItemsPage.qml \
    qml/pages/CategoriesPage.qml \
    qml/pages/CategoryAddDialog.qml \
    rpm/ru.farionik.moneyspent.MoneySpentApp.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.farionik.moneyspent.MoneySpentApp.ts \
    translations/ru.farionik.moneyspent.MoneySpentApp-ru.ts \
