package de.jona.gebetsglas.main

import android.app.*
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.database.Cursor
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import de.jona.gebetsglas.utils.DBHelper
import de.jona.gebetsglas.R
import de.jona.gebetsglas.receiver.NotificationSender
import kotlinx.android.synthetic.main.activity_notification.*
import java.util.*
import kotlin.collections.ArrayList

class NotificationActivity: AppCompatActivity() {

    val db: DBHelper =
        DBHelper(this)
    var checkedCategories: BooleanArray = booleanArrayOf()
    val categories: ArrayList<String> = ArrayList()
    var hour = 12
    var min = 0
    var checkedCa: MutableSet<String> = mutableSetOf()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification)


        //load data from shared Preferences
        val sharedPref = getSharedPreferences(getString(R.string.preference_file_key), Context.MODE_PRIVATE)
        hour = sharedPref.getInt(getString(R.string.preference_notification_hour), 12)
        min = sharedPref.getInt(getString(R.string.preference_notification_min), 0)
        checkedCa = sharedPref.getStringSet(getString(R.string.preference_notification_categories), checkedCa)
        notification_switch.isChecked = sharedPref.getBoolean(getString(R.string.preference_notification_enabled), false)

        //print Data to screen
        notification_category.text = getString(
            R.string.notification_categories,
            " ${checkedCa}"
        )
        notification_time.text = getString(R.string.notification_time, hour, min)

        val dbCursor: Cursor = db.getCategories()

        //save category names in Arraylist
        while (dbCursor.moveToNext()) {
            categories.add(dbCursor.getString(dbCursor.getColumnIndex(DBHelper.COL_NAME)))
        }
        checkedCategories = BooleanArray(categories.size)

        //Click listener for time picker
        notification_time.setOnClickListener {
            val timePickerDialog = TimePickerDialog(this, { view, hourOfDay, minute ->

                //Toast.makeText(this, "$hourOfDay:$minute", Toast.LENGTH_LONG).show()

                hour = hourOfDay
                min = minute

                notification_time.text = getString(R.string.notification_time, hourOfDay, minute)

            }, hour, min, true)
            timePickerDialog.show()
        }

        //set listener for category chooser
        notification_category.setOnClickListener {
            AlertDialog.Builder(this)
                .setMultiChoiceItems(
                    categories.toArray(arrayOf("")) as Array<String>,
                    checkedCategories,
                    { dialog, which, isChecked ->

                    })
                .setTitle(getString(R.string.notification_categories, ""))
                .setNegativeButton(
                    getString(R.string.cancel),
                    DialogInterface.OnClickListener { dialog, which ->

                    })
                .setPositiveButton(
                    getString(R.string.save),
                    DialogInterface.OnClickListener { dialog, which ->
                        for (i in checkedCategories.indices) {
                            if (checkedCategories[i]) {
                                checkedCa.add(categories[i])
                            }
                        }

                        notification_category.text = getString(
                            R.string.notification_categories,
                            " ${checkedCa}"
                        )

                        Log.d(MainActivity.PREFIX, "$checkedCa")
                    }).show()
        }

        notification_submit.setOnClickListener {

            val alarmManager: AlarmManager = getSystemService(ALARM_SERVICE) as AlarmManager

            val pendingIntent: PendingIntent =
                PendingIntent.getBroadcast(this, 0, Intent(this, NotificationSender::class.java), 0)

            alarmManager.cancel(pendingIntent)

            if (checkedCa.size == 0) {
                Toast.makeText(this, "Du musst mindestens eine Kategorie angeben", Toast.LENGTH_SHORT)
                return@setOnClickListener
            }

            if (notification_switch.isChecked) {

                //set new preferences
                with(sharedPref.edit()) {
                    putInt(getString(R.string.preference_notification_hour), hour)
                    putInt(getString(R.string.preference_notification_min), min)
                    putStringSet(getString(R.string.preference_notification_categories), checkedCa)
                    putBoolean(getString(R.string.preference_notification_enabled), true)
                    commit()
                }


                //set calendar to prefered date
                val c: Calendar = Calendar.getInstance()
                c.set(Calendar.HOUR_OF_DAY, hour)
                c.set(Calendar.MINUTE, min)

                var triggerAt = c.timeInMillis
                if (triggerAt < System.currentTimeMillis()) {
                    triggerAt += AlarmManager.INTERVAL_DAY
                }


                //set repeating alarm
                alarmManager.setInexactRepeating(
                    AlarmManager.RTC,
                    triggerAt,
                    AlarmManager.INTERVAL_DAY,
                    pendingIntent
                )

            } else {
                with(sharedPref.edit()) {
                    putBoolean(getString(R.string.preference_notification_enabled), false)
                    commit()
                }

            }

            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)

        }

    }
}