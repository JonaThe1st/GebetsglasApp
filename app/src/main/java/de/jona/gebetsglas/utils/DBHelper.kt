package de.jona.gebetsglas.utils

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import de.jona.gebetsglas.main.MainActivity

class DBHelper(context: Context): SQLiteOpenHelper(context,
    DATABASE_NAME, null, 1){

    companion object {
        val DATABASE_NAME = "GebetsglasDB"
        val TABLE_CATEGORIES = "categories"
        val COL_NAME = "name"
        val COL_DESCRIPTION = "description"
        val COL_ID = "id"

        val TABLE_ISSUES = "issues"
        val COL_ISSUEID = "issue_id"
        val COL_CATEGORY = "category"
    }

    override fun onCreate(db: SQLiteDatabase) {
        Log.d(MainActivity.PREFIX, "Tables created")
        db.execSQL("CREATE TABLE IF NOT EXISTS $TABLE_ISSUES(category, issue_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name text);")
        db.execSQL("CREATE TABLE IF NOT EXISTS $TABLE_CATEGORIES(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name text UNIQUE, description text, FOREIGN KEY (id) REFERENCES issues(category));")
        //db.execSQL("INSERT INTO categories('name', 'description') VALUES ('Kategorie 1', 'tolle Kategorie' )")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        //db.execSQL("DROP TABLE issues")
        //db.execSQL("DROP TABLE categories")
        Log.d(MainActivity.PREFIX, "OnUpgrade")
        onCreate(db)
    }

    fun addCategory(name: String, description: String): Long {
        val db: SQLiteDatabase = writableDatabase
        val contentValues: ContentValues = ContentValues()
        contentValues.put("name", name)
        contentValues.put("description", description)

        return db.insert(TABLE_CATEGORIES, null, contentValues)
    }

    fun addIssue(category_id: Int, name: String): Long {
        val db = writableDatabase
        val contentValues = ContentValues()
        contentValues.put("category", category_id)
        contentValues.put("name", name)

        return db.insert(TABLE_ISSUES, null, contentValues)
    }

    fun getCategories(): Cursor {
        val db = writableDatabase
        return db.rawQuery("SELECT * FROM $TABLE_CATEGORIES", null)
    }

    fun getCategory(id: Int): Cursor {
        val db = writableDatabase
        return db.rawQuery("SELECT * FROM $TABLE_CATEGORIES WHERE $COL_ID='$id'", null)
    }

    fun getCategoryByName(name: String): Cursor {
        val db = writableDatabase
        return db.rawQuery("SELECT * FROM $TABLE_CATEGORIES WHERE $COL_NAME='$name'", null)
    }

    fun getCategoryIdByName(name: String): Int {
        val cur:Cursor = getCategoryByName(name)
        cur.moveToFirst()
        return cur.getInt(cur.getColumnIndex(COL_ID))
    }

    fun getIssuesByCategory(category_id: Int): Cursor {
        val db = writableDatabase
        return db.rawQuery("SELECT * FROM $TABLE_ISSUES WHERE $COL_CATEGORY=$category_id", null)
    }

    fun deleteCategory(category_id: Int): Int {
        val db = writableDatabase
        db.delete(TABLE_ISSUES, "$COL_CATEGORY=$category_id", null)
        return db.delete(TABLE_CATEGORIES, "$COL_ID=$category_id", null)
    }

    fun deleteCategoryByName(name: String): Int {
        val cur: Cursor =getCategoryByName(name)
        cur.moveToFirst()
        val id: Int = cur.getInt(cur.getColumnIndex(COL_ID))
        return deleteCategory(id)
    }

    fun deleteIssue(id: Int): Int {
        val db = writableDatabase
        return db.delete(TABLE_ISSUES, "$COL_ISSUEID=$id", null)
    }

    fun getIssueByName(name: String, category_id: Int): Int {
        val db = writableDatabase
        val cur = db.rawQuery("SELECT * FROM $TABLE_ISSUES WHERE $COL_NAME='$name' AND $COL_CATEGORY=$category_id", null)
        cur.moveToFirst()
        return cur.getInt(cur.getColumnIndex(COL_ISSUEID))
    }

    fun deleteIssueByName(name: String, category_id: Int): Int {
        return deleteIssue(getIssueByName(name, category_id))
    }

    fun modifyCategory(category_id: Int, name: String, description: String): Int {
        val db = writableDatabase
        val contentValues: ContentValues = ContentValues()
        contentValues.put("name", name)
        contentValues.put("description", description)

        return db.update(TABLE_CATEGORIES, contentValues, "id=$category_id", null)
        //return db.rawQuery("UPDATE $TABLE_CATEGORIES SET $COL_NAME='$name', $COL_DESCRIPTION='$description' WHERE $COL_ID=$category_id", null)
    }

    fun modifyCategoryByName(oldName: String, newName: String, description: String): Int{
        val db = writableDatabase

        val cur: Cursor = getCategoryByName(oldName)
        cur.moveToFirst()
        return modifyCategory(cur.getInt(cur.getColumnIndex(COL_ID)), newName, description)
    }
}