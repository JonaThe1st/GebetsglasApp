package de.jona.gebetsglas.external

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import de.jona.gebetsglas.R
import de.jona.gebetsglas.external.avc.AvcActivity
import kotlinx.android.synthetic.main.activity_external.*

class ExternalActivity: AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_external)

        avc_text_view.setOnClickListener {
            startActivity(Intent(this, AvcActivity::class.java))
        }
    }


}