package de.jona.gebetsglas.main

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.database.Cursor
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.view.isVisible
import de.jona.gebetsglas.*
import de.jona.gebetsglas.category.CategoryActivity
import de.jona.gebetsglas.external.ExternalActivity
import de.jona.gebetsglas.utils.DBHelper
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity: ModifyCaActivity() {

    companion object {
        val PREFIX = "~~DEVELOPER_LOG~~: "
    }

    val db: DBHelper =
        DBHelper(this)
    var menuEnabled = true
    override val categories: ArrayList<String> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //TODO make own actionbar
        //setSupportActionBar(findViewById(R.id.my_toolbar))

        //CREATE DATABASE Helper
        db.onCreate(db.writableDatabase)

        //Start Category Activity on Click
        main_categories_list.onItemClickListener = object : AdapterView.OnItemClickListener {
            override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                Log.d(PREFIX, "Kategorie " + position + " angeklickt")

                val adapter: ArrayAdapter<String> = main_categories_list.adapter as ArrayAdapter<String>
                val cur = db.getCategoryByName(adapter.getItem(position) as String)
                cur.moveToFirst()
                val id: Int = cur.getInt(cur.getColumnIndex(DBHelper.COL_ID))
                Log.d(PREFIX, "thats the id: $id")

                val intent: Intent = Intent(this@MainActivity, CategoryActivity::class.java)
                    .apply { putExtra("id", id) }
                startActivity(intent)
            }
        }

        /*main_categories_list.setOnItemLongClickListener(AdapterView.OnItemLongClickListener { parent, view, position, id ->
            Toast.makeText(this, "haha", Toast.LENGTH_SHORT).show()
            return@OnItemLongClickListener true
        })*/

        main_categories_list.onItemLongClickListener = CustomLongClickListener()

        createNotificationChannel()
    }

    override fun onResume() {
        super.onResume()
        display()
    }

    override fun display() {

        //get all categories
        val dbCursor: Cursor = db.getCategories()
        categories.clear()

        //save category names in Arraylist
        while (dbCursor.moveToNext()) {
            categories.add(dbCursor.getString(dbCursor.getColumnIndex(DBHelper.COL_NAME)))
        }

        //If there is no category disable menuitem delete category
        menuEnabled = categories.size != 0
        main_demo.isVisible = !menuEnabled

        main_categories_list.adapter = MainList(
            this,
            R.layout.list_element_main,
            categories
        )
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.main_menu, menu)
        return true
    }

    override fun onPrepareOptionsMenu(menu: Menu): Boolean {
        menu.findItem(R.id.del_category).isEnabled = menuEnabled
        menu.findItem(R.id.notification_menu).isEnabled = menuEnabled
        return super.onPrepareOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        Log.d(PREFIX, "MenuItem Selected")
        Toast.makeText(this, item.title, Toast.LENGTH_LONG).show()

        //Start New Category activity
        if (item.title==getString(R.string.new_category)) {
            /*val intent = Intent(this, NewCaActivity::class.java)
            startActivity(intent)*/

            val inflater = layoutInflater
            val view = inflater.inflate(R.layout.dialog_ca, null)

            AlertDialog.Builder(this)
                .setView(view)
                .setNegativeButton(getString(R.string.cancel), { dialog, which ->

                })
                .setPositiveButton(getString(R.string.save), DialogInterface.OnClickListener { dialog, which ->
                    val name = view.findViewById<EditText>(R.id.dialog_ca_name).text.toString()
                    val description = view.findViewById<EditText>(R.id.dialog_ca_description).text.toString()

                    if (name == "") Toast.makeText(this, "du musst einen Namen angeben", Toast.LENGTH_LONG).show()
                    else {
                        db.addCategory(name, description)
                        display()
                        Toast.makeText(this, "Neue kategorie erstellt", Toast.LENGTH_LONG).show()
                    }
                }).show()


        } else if (item.title == getString(R.string.del_category)) {
            Toast.makeText(this, item.title.toString(), Toast.LENGTH_SHORT).show()

            startActivity(Intent(this, DelCategoryActivity::class.java))
        } else if (item.title == getString(R.string.notification_menu)) {
            Toast.makeText(this, item.title.toString(), Toast.LENGTH_SHORT).show()

            startActivity(Intent(this, NotificationActivity::class.java))
        } else if (item.title == getString(R.string.heading_external)) {
            startActivity(Intent(this, ExternalActivity::class.java))
        }

        return true
    }

    private fun createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(Notification.EXTRA_CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

}

























