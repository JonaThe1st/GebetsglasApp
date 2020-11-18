package de.jona.gebetsglas.receiver

import android.app.Notification
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import de.jona.gebetsglas.utils.DBHelper
import de.jona.gebetsglas.R
import de.jona.gebetsglas.main.MainActivity
import java.lang.StringBuilder
import kotlin.random.Random

class NotificationSender: BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        Toast.makeText(context, "Alarm", Toast.LENGTH_SHORT).show()

        val db = DBHelper(context)

        //get notification prefernces
        val sharedPref = context.getSharedPreferences(
            context.getString(R.string.preference_file_key),
            Context.MODE_PRIVATE)

        val categories: MutableSet<String> = sharedPref.getStringSet(
            context.getString(R.string.preference_notification_categories),
            mutableSetOf())
        if (categories.size == 0) {
            return
        }

        val randomIssues: ArrayList<String> = arrayListOf()
        val text = StringBuilder("Deine heutigen Gebetsanliegen:\n")
        with(sharedPref.edit()) {
        for (i in 0 until categories.size) {
            val issueCursor =
                db.getIssuesByCategory(db.getCategoryIdByName(categories.elementAt(i)))
            issueCursor.moveToPosition(Random.nextInt(issueCursor.count))
            val issue = issueCursor.getString(issueCursor.getColumnIndex(DBHelper.COL_NAME))

            text.append(i + 1)
            text.append(". ${categories.elementAt(i)}: $issue\n")
            randomIssues.add(issue)

            putString(context.getString(R.string.preferene_category_random, categories.elementAt(i)), issue)
        }
        commit()
    }
        val intent: Intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(context,0, intent, 0)

        var builder = NotificationCompat.Builder(context, Notification.EXTRA_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_bookmarks)
            .setContentTitle("Gebetsanliegen Erinnerung")
            .setStyle(NotificationCompat.BigTextStyle().bigText(text.toString()))
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        with (NotificationManagerCompat.from(context)) {
            notify(0, builder.build())
        }

    }

}