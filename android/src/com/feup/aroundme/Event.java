package com.feup.aroundme;

public class Event {
	
	private String id;
	private String title;
	private String startTime;
	private String endTime;
	private String location;
	private String lat;
	private String log;
	private String venue;
	
	public Event(String id, String title, String startTime, String endTime,
			String location, String lat, String log) {
		super();
		this.id = id;
		this.title = title;
		this.startTime = startTime;
		this.endTime = endTime;
		this.location = location;
		this.lat = lat;
		this.log = log;
		this.venue = null;
	}
	
	public Event(String _id, String _title, String _sT, String _eT, String _loc){
		this.id = _id;
		this.title = _title;
		this.startTime = _sT;
		this.endTime = _eT;
		this.location = _loc;
		this.venue = null;
	}

	public Event(String string, String string2, String string3, String string4) {
		this.id = string;
		this.title = string2;
		this.startTime = string3;
		this.location = string4;
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLog() {
		return log;
	}
	public void setLog(String log) {
		this.log = log;
	}

	public void setVenue(String venue) {
		this.venue = venue;
	}
	public String getVenue() {
		return venue;
	}


}
