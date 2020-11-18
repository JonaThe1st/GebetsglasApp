package de.jona.gebetsglas.unused

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
//import kotlinx.android.synthetic.main.activity_new_ca.*
//import kotlinx.android.synthetic.main.activity_new_is.*

class NewIsActivity: AppCompatActivity() {

    /*val db: DBHelper = DBHelper(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_new_is)

        submit_new_is.setOnClickListener{ v -> run{
            val name: String = new_is_name.text.toString()

            if (name.equals("")) Toast.makeText(this, "du musst einen Namen angeben", Toast.LENGTH_LONG).show()
            else {
                val cId = intent.getIntExtra("cId", -1)
                db.addIssue(cId, name)
                Toast.makeText(this, "erfolgreich gespeichert", Toast.LENGTH_LONG).show()

                Log.d(MainActivity.PREFIX, "THis is the activity id $cId")
                val intent = Intent(this@NewIsActivity, CategoryActivity::class.java)
                intent.putExtra("id", cId)
                startActivity(intent)
            }

        }}
    }*/

}