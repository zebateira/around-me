package com.feup.aroundme;

import com.feup.aroundme.R;
import com.feup.aroundme.R.layout;
import com.feup.aroundme.other.AppPreferences;
import com.feup.aroundme.other.fb.FacebookConnect;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class HomeActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_home);
    
    // Button Listeners
    Button skip = (Button) findViewById(R.id.btnSkip);
	skip.setOnClickListener(new View.OnClickListener() {
		@Override
		public void onClick(View arg0) {
			onClickFeature(arg0);
		}
		
	});
	
	 Button btnFB = (Button) findViewById(R.id.btnFB);
	 btnFB.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0) {
				 startActivity (new Intent(getApplicationContext(), FacebookConnect.class));
			}
			
		});
	
	// Button Listeners
    Button settings = (Button) findViewById(R.id.btnSettings);
    settings.setOnClickListener(new View.OnClickListener() {
		@Override
		public void onClick(View arg0) {
			onClickFeature(arg0);
		}
		
	});
    
	// Button Listeners
    Button exit = (Button) findViewById(R.id.btnLeave);
    exit.setOnClickListener(new View.OnClickListener() {
		@Override
		public void onClick(View arg0) {
			finish();
		}
		
	});
    
    // First time of execution?
    /*
    SharedPreferences myPrefs = this.getPreferences(MODE_WORLD_READABLE);
    SharedPreferences.Editor prefsEditor = myPrefs.edit();
    if (myPrefs.getString("first", null) == null) {
	    prefsEditor.putString("first", "0");
	    prefsEditor.commit();
	    AppPreferences appPrefs;
	    appPrefs.saveString("access_token", null);
    }
    */

	
}
    
protected void onDestroy ()
{
   super.onDestroy ();
}

protected void onPause ()
{
   super.onPause ();
}

protected void onRestart ()
{
   super.onRestart ();
}

protected void onResume ()
{
   super.onResume ();
}

protected void onStart ()
{
   super.onStart ();
}

protected void onStop ()
{
   super.onStop ();
}


/**
 */
// More Methods

} // end class
