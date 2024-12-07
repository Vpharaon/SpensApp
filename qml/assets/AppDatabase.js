function initDatabase()
{
    var db = LocalStorage.openDatabaseSync("App_DB", "", "Database for storing user expenses and income", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS category_table (id INTEGER PRIMARY KEY AUTOINCREMENT, category_name TEXT NOT NULL, type INT NOT NULL, UNIQUE(id))')
            tx.executeSql('CREATE TABLE IF NOT EXISTS budget_table (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, value DOUBLE, category_id INT, category_type INT, comment TEXT)')

            // добавляем сразу несколько категорий, чтоб пользователь мог с чем-то работать

            // добавить категории расходов type = 1 это расходы
            insertCategory("Еда", 1)
            insertCategory("Жилье", 1)
            insertCategory("Развлечения", 1)
            insertCategory("Одежда", 1)
            insertCategory("Подарки", 1)
            insertCategory("Питомцы", 1)
            insertCategory("Транспорт", 1)

            // добавить категории доходов type = 0 это доходы
            insertCategory("Зарплата", 0)
            insertCategory("Депозиты", 0)
            insertCategory("Сбережения", 0)
            insertCategory("Переводы", 0)
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("App_DB", "", "Database for storing user expenses and income", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function insertCategory(categoryName, type)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT OR IGNORE INTO category_table(category_name, type) VALUES(?, ?)', [categoryName, type])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    //console.log(rowid)
    return rowid;
}

function deleteCategory(id) {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql("DELETE FROM category_table WHERE id = ?", [id]);
    });
}

function getAllCategories(callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM category_table");
        callback(result.rows);
    });
}

function getAllCategoriesByType(type, callback) {
    console.log(type)
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM category_table WHERE type = ?", [type]);
        callback(result.rows);
    });
}

function getCategory(categoryId, callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM category_table WHERE id = ?", [categoryId]);
        callback(result.rows.item(0));
    });
}

// функции по работе с таблицей буджета

// добавление новой записи в таблицу бюджета
function insertBudgetItem(title, value, comment, category_id, category_type) {
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT OR IGNORE INTO budget_table(title, value, category_id, category_type, comment) VALUES(?, ?, ?, ?, ?)', [title, value, category_id, category_type, comment])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    console.log(rowid)
    return rowid;
}

function getBudgetItem(id, callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM budget_table WHERE id = ?", [id]);
        callback(result.rows.item(0));
    });
}

// получить все записи из таблицы бюджета
function getAllBudgetItems(callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM budget_table");
        callback(result.rows);
    });
}

// получить записи из базы по определенному типу категории
function getAllBudgetItemsByCategoryType(type, callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM budget_table WHERE category_type = ?", [type]);
        callback(result.rows);
    });
}
