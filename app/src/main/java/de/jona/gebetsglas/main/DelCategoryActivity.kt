package de.jona.gebetsglas.main

import android.database.Cursor
import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import de.jona.gebetsglas.category.CheckBoxList
import de.jona.gebetsglas.utils.DBHelper
import de.jona.gebetsglas.R
import kotlinx.android.synthetic.main.activity_del_ca.*

class DelCategoryActivity: ModifyCaActivity() {

    val db: DBHelper =
        DBHelper(this)

    override val categories: ArrayList<String> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_del_ca)

        display()

        del_categories_list.onItemLongClickListener = CustomLongClickListener()

        del_category_submit.setOnClickListener {
            AlertDialog.Builder(this)
                .setNegativeButton(getString(R.string.cancel), { dialog, which -> })
                .setPositiveButton(getString(R.string.delete), { dialog, which ->
                    val checkedFields: Array<String> =
                        (del_categories_list.adapter as CheckBoxList).getChecked()

                    for (item in checkedFields) {
                        db.deleteCategoryByName(item)
                    }
                    finish()
                })
                .setMessage(getString(R.string.del_alert))
                .show()

        }
    }

    override fun display() {

        val dbCursor: Cursor = db.getCategories()
        categories.clear()

        //save category names in Arraylist
        while (dbCursor.moveToNext()) {
            categories.add(dbCursor.getString(dbCursor.getColumnIndex(DBHelper.COL_NAME)))
        }
        del_categories_list.adapter = CheckBoxList(
            this,
            R.layout.del_ca_list_element,
            categories
        )

    }

}