package com.feup.aroundme;

import java.util.ArrayList;

public class Marker {

	private String venue;
	private String title;
	private String location;
	private ArrayList<Event> events;
	
	public Marker(String title2, String venue, String location) {
		this.venue = venue;
		this.title = title2;
		this.location = location;
		events = new ArrayList<Event>();
	}
	public String getVenue() {
		return venue;
	}
	public String getTitle() {
		return title;
	}
	public ArrayList<Event> getEvents() {
		return events;
	}
	public void setVenue(String venue) {
		this.venue = venue;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public void setEvents(ArrayList<Event> events) {
		this.events = events;
	}

	public void addEvent(Event e) {
		events.add(e);
	}
	public String getLocation() {
		return location;
	}
	
	
	
}
