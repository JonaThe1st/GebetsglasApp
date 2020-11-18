package de.jona.gebetsglas.category

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import de.jona.gebetsglas.utils.DBHelper
import de.jona.gebetsglas.R
import kotlinx.android.synthetic.main.activity_del_is.*

class DelIsActivity: AppCompatActivity() {

    val db: DBHelper =
        DBHelper(this)
    var id: Int = -1


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_del_is)

        id = intent.getIntExtra("id", -1)

        val cur = db.getIssuesByCategory(id)
        val issues = ArrayList<String>()
        while (cur.moveToNext()) {
            issues.add(cur.getString(cur.getColumnIndex(DBHelper.COL_NAME)))
        }

        del_is_list.adapter = CheckBoxList(
            this,
            R.layout.del_ca_list_element,
            issues
        )

        del_is_submit.setOnClickListener {
            AlertDialog.Builder(this)
                .setMessage(getString(R.string.del_alert))
                .setNegativeButton(getString(R.string.cancel), { dialog, which -> })
                .setPositiveButton(getString(R.string.delete), { dialog, which ->
                    val checkedFields: Array<String> = (del_is_list.adapter as CheckBoxList).getChecked()
                    Toast.makeText(this, "löschen", Toast.LENGTH_LONG).show()
                    for (item in checkedFields) {
                        db.deleteIssueByName(item, id)
                    }
                    finish()
                }).show()
        }
    }

}