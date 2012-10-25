package com.feup.aroundme;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.ListView;
import android.widget.TextView;

public class EventsMenuCategoriesActivity extends Activity {
  
  private ListView mainListView ;
  private Category[] categories ;
  private ArrayAdapter<Category> listAdapter ;
  
  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //setContentView(R.layout.main);
    setContentView(R.layout.main);
    
    // Find the ListView resource. 
    mainListView = (ListView) findViewById( R.id.mainListView );
    
    mainListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick( AdapterView<?> parent, View item, 
                               int position, long id) {
        Category planet = listAdapter.getItem( position );
        planet.toggleChecked();
        CategoryViewHolder viewHolder = (CategoryViewHolder) item.getTag();
        viewHolder.getCheckBox().setChecked( planet.isChecked() );
      }
    });

    
    categories = (Category[]) getLastNonConfigurationInstance() ;
    if ( categories == null ) {
    	categories = new Category[] { 
          new Category("Teatro"), new Category("Musica")
      };  
    }
    ArrayList<Category> planetList = new ArrayList<Category>();
    planetList.addAll( Arrays.asList(categories) );
    
    // Set our custom array adapter as the ListView's adapter.
    listAdapter = new CategoryArrayAdapter(this, planetList);
    mainListView.setAdapter( listAdapter );      
  }
  
  private static class Category {
    private String name = "" ;
    private boolean checked = false ;
    public Category() {}
    public Category( String name ) {
      this.name = name ;
    }
    public Category( String name, boolean checked ) {
      this.name = name ;
      this.checked = checked ;
    }
    public String getName() {
      return name;
    }
    public void setName(String name) {
      this.name = name;
    }
    public boolean isChecked() {
      return checked;
    }
    public void setChecked(boolean checked) {
      this.checked = checked;
    }
    public String toString() {
      return name ; 
    }
    public void toggleChecked() {
      checked = !checked ;
    }
  }
  
  /** Holds child views for one row. */
  private static class CategoryViewHolder {
    private CheckBox checkBox ;
    private TextView textView ;
    public CategoryViewHolder() {}
    public CategoryViewHolder( TextView textView, CheckBox checkBox ) {
      this.checkBox = checkBox ;
      this.textView = textView ;
    }
    public CheckBox getCheckBox() {
      return checkBox;
    }
    public void setCheckBox(CheckBox checkBox) {
      this.checkBox = checkBox;
    }
    public TextView getTextView() {
      return textView;
    }
    public void setTextView(TextView textView) {
      this.textView = textView;
    }    
  }
  
  private static class CategoryArrayAdapter extends ArrayAdapter<Category> {
    
    private LayoutInflater inflater;
    
    public CategoryArrayAdapter( Context context, List<Category> categoryList ) {
      super( context, R.layout.simplerow, R.id.rowTextView, categoryList );
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(context) ;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      // Planet to display
      Category cat = (Category) this.getItem( position ); 

      // The child views in each row.
      CheckBox checkBox ; 
      TextView textView ; 
      
      // Create a new row view
      if ( convertView == null ) {
        convertView = inflater.inflate(R.layout.simplerow, null);
        
        // Find the child views.
        textView = (TextView) convertView.findViewById( R.id.rowTextView );
        checkBox = (CheckBox) convertView.findViewById( R.id.CheckBox01 );
        
        // Optimization: Tag the row with it's child views, so we don't have to 
        // call findViewById() later when we reuse the row.
        convertView.setTag( new CategoryViewHolder(textView,checkBox) );

        checkBox.setOnClickListener( new View.OnClickListener() {
          public void onClick(View v) {
            CheckBox cb = (CheckBox) v ;
            Category cat = (Category) cb.getTag();
            cat.setChecked( cb.isChecked() );
          }
        });        
      }
      // Reuse existing row view
      else {
        // Because we use a ViewHolder, we avoid having to call findViewById().
        CategoryViewHolder viewHolder = (CategoryViewHolder) convertView.getTag();
        checkBox = viewHolder.getCheckBox() ;
        textView = viewHolder.getTextView() ;
      }

      checkBox.setTag( cat ); 
      
      // Display data
      checkBox.setChecked( cat.isChecked() );
      textView.setText( cat.getName() );      
      
      return convertView;
    }
    
  }
  
  public Object onRetainNonConfigurationInstance() {
    return categories ;
  }
}