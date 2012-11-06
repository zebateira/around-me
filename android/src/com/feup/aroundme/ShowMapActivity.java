package com.feup.aroundme;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.AsyncFacebookRunner.RequestListener;
import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;
import com.feup.aroundme.R;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

public class ShowMapActivity extends MapActivity {
	
	// TODO:
	// APP_ID e PERMS no xml
	
	// Facebook
	public static final String APP_ID = "your_id_here"; 
	public static final String TAG = "FACEBOOK CONNECT";
	private static final String[] PERMS = new String[] { "user_events" };
	private static final String[] PAGES = new String[] { "me/events", "casadamusica/events" };
	private Facebook mFacebook;
	private AsyncFacebookRunner mAsyncRunner;
	private ArrayList<Event> events = new ArrayList<Event>();
	private ArrayList<Event> eventsExt = new ArrayList<Event>();
	private ArrayList<Marker> markers = new ArrayList<Marker>();
	// Google Map
	MapView mapView = null;
	private SharedPreferences mPrefs;
	private ReadWriteLock lock = new ReentrantReadWriteLock();
	private ReadWriteLock lock2 = new ReentrantReadWriteLock();
	Random randomGenerator = new Random();
		
	@Override
	protected boolean isRouteDisplayed() {
	    return false;
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.activity_show_map);
	    
	    mapView = (MapView) findViewById(R.id.mapview);
	    mapView.setBuiltInZoomControls(true);
	    
	    // Initialize Facebook session
	    // TODO only if has Internet / logged in
	    mFacebook = new Facebook(APP_ID);
	    mAsyncRunner = new AsyncFacebookRunner(mFacebook);
	    
	    
	    mPrefs = this.getSharedPreferences("appPrefs", MODE_WORLD_READABLE);
        String access_token = mPrefs.getString("access_token", null);
        long expires = mPrefs.getLong("access_expires", 0);
        if(access_token != null) {
        	mFacebook.setAccessToken(access_token);
        	Log.d(TAG, "Acess token is: " + access_token);
        }
        else {Log.d(TAG, "No access token");}
        if(expires != 0) {
        	mFacebook.setAccessExpires(expires);
        }
	   	    
	    for(String s: PAGES) {
	    	mAsyncRunner.request(s, new EventRequestListener());
	    }
	    
	    /*
	    for(Marker m: markers) {
	    	renderMarker(m);
	    }*/
	    
	    /*
	    for(Event e: eventsExt) {
	    	addEvent(e);
	    }*/
	    
	   
	    
	    //render markers

	    // Check if FB is on
	    // Check if Internet on
	    // Check if data stored sql
	}
	

	private void renderMarker(Event ev) {
		List<Overlay> mapOverlays = mapView.getOverlays();
	    Drawable drawable = this.getResources().getDrawable(R.drawable.marker);
	    MapItemOverlay itemizedoverlay = new MapItemOverlay(drawable, this);
	    
	    String r;
		try {
			r = mFacebook.request(ev.getVenue());
			final JSONObject json = new JSONObject(r);
			final JSONObject json2 = new JSONObject(json.getString("location"));
			GeoPoint point = new GeoPoint((int) (Double.parseDouble(json2.getString("latitude")) * 1E6) + randomGenerator.nextInt(1000) , (int) (Double.parseDouble(json2.getString("longitude")) * 1E6) + randomGenerator.nextInt(1000));
			
			String eventList = ev.getTitle();
			/*
			for (Event e: m.getEvents()) {
				eventList = eventList + e.getTitle() + ":" + e.getStartTime() + "\n";
			}*/
			OverlayItem overlayitem = new OverlayItem(point, ev.getLocation(), eventList);
			
		    itemizedoverlay.addOverlay(overlayitem);
		    mapOverlays.add(itemizedoverlay);	
		} catch (MalformedURLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	
	}
	
	

	private Marker addEvent(Event event) {

	    	if (event.getVenue() != null) {
	    		
	    		Marker toRet = null;
	    		//Marker[] arrayMarkers = (Marker[]) markers.toArray();
	    		lock2.readLock().lock();
		        try {
		        	for (Marker m: markers) {
		    			if (m.getVenue() == event.getVenue()) {
		    				m.addEvent(event);
		    				lock2.readLock().unlock();
		    				return m;
		    			}
		    		}
		        	toRet = new Marker(event.getTitle(), event.getVenue(), event.getLocation());
		        	markers.add(toRet);
		        } finally {
		            lock2.readLock().unlock();
		            return toRet;
		        }
	    		
	    		
	    		
	    		/*
	    		String r = mFacebook.request(event.getVenue());
	    		final JSONObject json = new JSONObject(r);
	    		final JSONObject json2 = new JSONObject(json.getString("location"));
	 
	    		GeoPoint point = new GeoPoint((int) (Double.parseDouble(json2.getString("latitude")) * 1E6) , (int) (Double.parseDouble(json2.getString("longitude")) * 1E6));
	    	    OverlayItem overlayitem = new OverlayItem(point, event.getTitle(), "I'm in Mexico City!");
	    	    
	    	    itemizedoverlay.addOverlay(overlayitem);
	    	    mapOverlays.add(itemizedoverlay);*/
	    	}
		/*} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
			return null;
	    	    
	}
	
	// Facebook RequestListeners
	private class EventRequestListener implements RequestListener {
		 
		public void onComplete(String response, Object state) {
			try {
				// process the response here: executed in background thread
				Log.d(TAG, "Response: " + response.toString());
				final JSONObject json = new JSONObject(response);
				JSONArray d = json.getJSONArray("data");
	 
				for (int i = 0; i < d.length(); i++) {
					JSONObject event = d.getJSONObject(i);
					Event newEvent = new Event(event.getString("id"),
							event.getString("name"),
							event.getString("start_time"),
							event.getString("location"));
					events.add(newEvent);
				}
 
				// then post the processed result back to the UI thread
				// if we do not do this, an runtime exception will be generated
				// e.g. "CalledFromWrongThreadException: Only the original
				// thread that created a view hierarchy can touch its views."
				ShowMapActivity.this.runOnUiThread(new Runnable() {
					

					public void run() {
						for (Event event: events) {
							try {
								String r = mFacebook.request(event.getId());
								JSONObject json = new JSONObject(r);
								JSONObject venues = new JSONObject(json.getString("venue"));
								event.setVenue(venues.getString("id"));
								// TODO if there is no venue go on
							} catch (MalformedURLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
							//eventsExt.add(event);
							lock.readLock().lock();
					        try {
					        	Marker m = addEvent(event);
					        	if (m != null)
					        		renderMarker(event);
					        } finally {
					        	/*for(Marker m: markers) {
					    	    	renderMarker(m);
					    	    }*/
					            lock.readLock().unlock();
					        }
							
							Object o = null;
						}
					}
				});
			} catch (JSONException e) {
				Log.w(TAG, "JSON Error in response");
				Log.w(TAG, e.getMessage());
			}
		}
	 
		public void onIOException(IOException e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFileNotFoundException(FileNotFoundException e,
				Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onMalformedURLException(MalformedURLException e,
				Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFacebookError(FacebookError e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	}
	


} // end class
