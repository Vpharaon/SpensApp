function initDatabase()
{
    var db = LocalStorage.openDatabaseSync("App_DB", "", "Database for storing user expenses and income", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS category_table (id INTEGER PRIMARY KEY AUTOINCREMENT, category_name TEXT NOT NULL)')
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

function insertCategory(categoryName)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO category_table(category_name) VALUES(?)', [categoryName])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
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

function getCategory(categoryId, callback) {
    var db = dbGetHandle()
    db.readTransaction(function (tx) {
        var result = tx.executeSql("SELECT * FROM category_table WHERE id = ?", [categoryId]);
        callback(result.rows.item(0));
    });
}
