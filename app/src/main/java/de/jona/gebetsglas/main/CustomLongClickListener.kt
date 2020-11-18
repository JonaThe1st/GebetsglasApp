package de.jona.gebetsglas.main

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.Toast
import de.jona.gebetsglas.R
import de.jona.gebetsglas.utils.DBHelper
import kotlinx.android.synthetic.main.dialog_ca.view.*

class CustomLongClickListener: AdapterView.OnItemLongClickListener {


    override fun onItemLongClick(
        parent: AdapterView<*>?,
        view: View,
        position: Int,
        id: Long
    ): Boolean {

        if (view?.context is ModifyCaActivity) {

            val context: ModifyCaActivity = view.context as ModifyCaActivity
            val db: DBHelper = DBHelper(context)

            val caName: String = context.categories[position]

            val cur = db.getCategoryByName(caName)
            cur.moveToFirst()
            val caDescription: String = cur.getString(cur.getColumnIndex(DBHelper.COL_DESCRIPTION))
            val caId: Int = cur.getInt(cur.getColumnIndex(DBHelper.COL_ID))

            val dialogView = View.inflate(context, R.layout.dialog_ca, null)

            dialogView.dialog_ca_heading.text = context.getString(R.string.modify_ca_heading)
            dialogView.dialog_ca_name.setText(caName)
            dialogView.dialog_ca_description.setText(caDescription)

            AlertDialog.Builder(context)
                .setView(dialogView)
                .setNegativeButton(context.getString(R.string.cancel), DialogInterface.OnClickListener { dialog, which ->

                })
                .setPositiveButton(context.getString(R.string.save), DialogInterface.OnClickListener { dialog, which ->

                    val newName: String = dialogView.dialog_ca_name.text.toString()
                    val newDescription: String = dialogView.dialog_ca_description.text.toString()

                    if (newName == "") {
                        Toast.makeText(context, "Kategorie braucht einen Namen", Toast.LENGTH_SHORT).show()
                        return@OnClickListener
                    }


                    Log.d(MainActivity.PREFIX, "id=$caId, newName=$newName, newDescription=$newDescription, oldname=$caName")
                    //safe modified data
                    db.modifyCategory(caId, newName, newDescription)

                    //actualize sharedPrefs
                    val sharedPref: SharedPreferences = context.getSharedPreferences(
                        context.getString(R.string.preference_file_key),
                        Context.MODE_PRIVATE)


                    val notificationCa: MutableSet<String> = sharedPref.getStringSet(context.getString(R.string.preference_notification_categories), mutableSetOf())
                    if (caName in notificationCa) {


                        notificationCa.remove(caName)
                        notificationCa.add(newName)

                        Log.d(MainActivity.PREFIX, "$notificationCa")
                        val randomIssue = sharedPref.getString(context.getString(R.string.preferene_category_random, caName), "")

                        with(sharedPref.edit()) {
                            putStringSet(context.getString(R.string.preference_notification_categories), notificationCa)

                            remove(context.getString(R.string.preferene_category_random, caName))
                            putString(context.getString(R.string.preferene_category_random, newName), randomIssue)

                            commit()
                        }
                    }

                    context.display()
                    Toast.makeText(context, "Kategorie erfolgreich berbeitet", Toast.LENGTH_SHORT).show()

                })
                .setNeutralButton(context.getString(R.string.delete), DialogInterface.OnClickListener { dialog, which ->
                    AlertDialog.Builder(context)
                        .setMessage("Bist du dir sicher, dass du die Kategorie $caName löschen willst?")
                        .setNegativeButton(context.getString(R.string.cancel), DialogInterface.OnClickListener { dialog, which ->  })
                        .setPositiveButton(context.getString(R.string.delete), DialogInterface.OnClickListener { dialog, which ->
                            db.deleteCategory(caId)
                            Toast.makeText(context, "Kategorie erfolgreich gelöscht",Toast.LENGTH_SHORT).show()
                            context.display()
                        })
                        .show()

                })
                .show()

            return true


        } else {
            return false
        }
    }

}