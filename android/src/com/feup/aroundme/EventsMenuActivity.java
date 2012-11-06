package com.feup.aroundme;

import java.util.ArrayList;
import java.util.Vector;

import com.feup.aroundme.R;
import com.feup.aroundme.other.MyCustomAdapter;
import com.feup.aroundme.other.Parent;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ExpandableListView;

public class EventsMenuActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.activity_events_menu);
    setTitleFromActivityLabel (R.id.title_text);
    
    findViewById(R.id.seekBar1).setVisibility(View.GONE);
    findViewById(R.id.txtRadius).setVisibility(View.GONE);
    findViewById(R.id.spinnerCategories).setVisibility(View.GONE);
    
    // spinnerfill
    
}
    
} // end class
