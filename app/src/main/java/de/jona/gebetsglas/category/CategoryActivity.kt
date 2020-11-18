package de.jona.gebetsglas.category

import android.app.AlertDialog
import android.app.SearchManager
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.database.Cursor
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.SearchView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import de.jona.gebetsglas.utils.DBHelper
import de.jona.gebetsglas.R
import de.jona.gebetsglas.main.MainActivity
import kotlinx.android.synthetic.main.activity_category.*
import java.util.regex.Pattern
import kotlin.collections.ArrayList
import kotlin.random.Random

class CategoryActivity: AppCompatActivity(), SearchView.OnQueryTextListener {

    var id: Int = -1
    val db = DBHelper(this)

    var issues: ArrayList<String> = ArrayList()
    var menuEnabled = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_category)

        //setSupportActionBar(findViewById(R.id.my_toolbar))

        id = intent.getIntExtra("id", -1)

        val cur: Cursor = db.getCategory(id)
        cur.moveToFirst()

        category_heading.text = cur.getString(cur.getColumnIndex(DBHelper.COL_NAME))
        category_description.text = cur.getString(cur.getColumnIndex(DBHelper.COL_DESCRIPTION))

        category_description.isVisible = category_description.text != ""

        //Display random issue on Click
        category_random.setOnClickListener {
            val randomIssue: String= issues[Random.nextInt(issues.size)]

            AlertDialog.Builder(this)
                .setPositiveButton("Ok", { dialog, which -> })
                .setMessage(randomIssue)
                .show()

            Toast.makeText(this, randomIssue, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onResume() {
        super.onResume()
        displayIssues()
    }

    private fun displayIssues() {
        val issuesCursor = db.getIssuesByCategory(id)

        issues = ArrayList()

        while (issuesCursor.moveToNext()) {
            issues.add(issuesCursor.getString(issuesCursor.getColumnIndex(DBHelper.COL_NAME)))
        }

        //disable buttons if theres no issue
        menuEnabled = issues.size != 0
        category_random.isEnabled = menuEnabled
        category_random.isVisible = menuEnabled
        category_demo.isVisible = !menuEnabled


        category_list.adapter = ArrayAdapter(this,
            R.layout.list_element, issues)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater = menuInflater
        inflater.inflate(R.menu.category_menu, menu)

        val searchManager = getSystemService(Context.SEARCH_SERVICE) as SearchManager
        (menu.findItem(R.id.category_search).actionView as SearchView).apply {
            setSearchableInfo(searchManager.getSearchableInfo(componentName))
            isSubmitButtonEnabled = true
            setOnQueryTextListener(this@CategoryActivity)
        }


        return true
    }

    override fun onPrepareOptionsMenu(menu: Menu): Boolean {
        menu.findItem(R.id.del_is).isEnabled = menuEnabled
        menu.findItem(R.id.category_search).isEnabled = menuEnabled
        return super.onPrepareOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        Log.d(MainActivity.PREFIX, "MenuItem Selected")
        Toast.makeText(this, item.title, Toast.LENGTH_LONG).show()

        //Start UserDialog for new Issue
        if (item.title== getString(R.string.new_issue)){
            /*val intent = Intent(this, NewIsActivity::class.java)
                .apply { putExtra("cId", id) }
            startActivity(intent)*/

            val inflater = layoutInflater
            val view = inflater.inflate(R.layout.dialog_new_is, null)

            AlertDialog.Builder(this)
                .setView(view)
                //set positive button
                .setPositiveButton(getString(R.string.save), DialogInterface.OnClickListener { dialogInterface, i ->

                    //Gebetsanliegen in db einfügen
                    Log.d(MainActivity.PREFIX, "this is the new is compontent ${R.id.new_is}")
                    val name: String = view.findViewById<EditText>(R.id.new_is).text.toString()

                    if (name == "") Toast.makeText(this, "du musst einen Namen angeben", Toast.LENGTH_LONG).show()
                    else {
                        db.addIssue(id, name)
                        displayIssues()
                        Toast.makeText(this, "erfolgreich gespeichert", Toast.LENGTH_LONG).show()
                    }

                })
                //set negative button
                .setNegativeButton(getString(R.string.cancel), DialogInterface.OnClickListener { dialogInterface, i ->
                    Toast.makeText(applicationContext, "Nothing Happened", Toast.LENGTH_LONG).show()
                })
                .show()
        } else if (item.title == getString(R.string.del_is)) {

            val intent = Intent(this, DelIsActivity::class.java)
                .apply { putExtra("id", id) }
            startActivity(intent)
        }

        return true
    }

    override fun onQueryTextChange(newText: String?): Boolean {

        val queryList: ArrayList<String> = ArrayList()

        val pattern = Pattern.compile(newText, Pattern.CASE_INSENSITIVE)
        for (item in issues) {
            if (pattern.matcher(item).find()) {
                queryList.add(item)
            }
        }

        category_list.adapter = ArrayAdapter(this,
            R.layout.list_element, queryList)


        return true
    }

    override fun onQueryTextSubmit(query: String?): Boolean {
        Toast.makeText(this, query, Toast.LENGTH_SHORT).show()
        return true
    }

    override fun onBackPressed() {
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
    }

}