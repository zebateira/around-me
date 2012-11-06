package com.feup.aroundme;

import com.feup.aroundme.R;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class SettingsActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.activity_settings);
    setTitleFromActivityLabel (R.id.title_text);
    
    // Limit Zones -> Popup
    // Settings FB:
    	// import lists
    
    Button btnSettingsFB = (Button) findViewById(R.id.btnSettingsFB);
    btnSettingsFB.setOnClickListener(new View.OnClickListener() {
		@Override
		public void onClick(View arg0) {
			onClickFeature(arg0);
		}
		
	});
}
    
} // end class
