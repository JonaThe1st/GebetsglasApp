package de.jona.gebetsglas.unused

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
//import kotlinx.android.synthetic.main.activity_new_ca.*
import android.content.DialogInterface
import androidx.core.app.ComponentActivity
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T



class NewCaActivity: AppCompatActivity() {

    /*val db: DBHelper = DBHelper(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_new_ca)

        submit_new_ca.setOnClickListener{ v -> run{
            val name: String = new_ca_name.text.toString()
            val description = new_ca_description.text.toString()

            if (name.equals("")) Toast.makeText(this, "du musst einen Namen angeben", Toast.LENGTH_LONG).show()
            else {
                db.addCategory(name, description)
                Toast.makeText(this, "erfolgreich gespeichert", Toast.LENGTH_LONG).show()

                val intent = Intent(this@NewCaActivity, MainActivity::class.java)
                startActivity(intent)
            }

        }}
    }*/

}