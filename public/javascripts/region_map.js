var RegionMap = Class.create({
  initialize: function(container_id, region, boundary_editing, type_colours) {
    this.container_id  = container_id;
    this.map = null;
    this.boundary = null;
    this.boundary_markers = [];
    this.pin_markers = {};
    this.pin_details = [];
    this.region = region;
    this.boundary_editing = boundary_editing;
    this.type_colours = type_colours;
  },

  load: function() {
    if (GBrowserIsCompatible()) {
      this.loaded = true;
      this.map = new GMap2(document.getElementById(this.container_id), {mapTypes: [G_NORMAL_MAP]});
      this.map.setCenter(new GLatLng(this.region.center_lat, this.region.center_lon), this.region.default_zoom);
			this.map.addControl(new GLargeMapControl());
			if (this.boundary_editing) {
  			this.enableBoundaryEditing();				  
			}
    }
  },
  
  displayPins: function(pins) {
    pins.each(function(pin) {
      point = new GLatLng(pin.lat, pin.long)

      var icon = new GIcon(G_DEFAULT_ICON);
      icon.image = "/pin_images/" + pin.to_param + '.png';

      var marker = new GMarker(point, {title: pin.name, icon: icon});
      this.map.addOverlay(marker);
      this.pin_markers[pin.to_param] = marker;
      marker.bindInfoWindowHtml(this.infoWindowHtml(pin));    
    }, this);
    
    this.pin_details = pins;
  },
  
  showAllTypes: function() {
    this.pin_details.each(function(pin) {
      var marker = this.pin_markers[pin.to_param];
      this.setDefaultColour(marker, pin);
      marker.show();
    }, this);    
  },
  
  showOnlyOneType: function(type_name) {
    this.pin_details.each(function(pin) {
      var marker = this.pin_markers[pin.to_param];
      if (pin.resource_types.include(type_name)) {
        marker.show();
        this.setColour(marker, pin, this.type_colours[type_name]);
      } else {
        marker.hide();
      }
    }, this);
  },
  
  setColour: function(marker, pin, colour) {
    var image_url = "/pin_images/" + colour + "-" + pin.id + '.png';
    marker.setImage(image_url);    
  },
  
  setDefaultColour: function(marker, pin) {
    var image_url = "/pin_images/" + pin.to_param + '.png';
    marker.setImage(image_url);
  },
  
  centerOnPinIfHash: function() {
    if (document.location.hash) {
      param = unescape(document.location.hash.substring(1));
      this.centerOnPin(param);
    }
  },
  
  infoWindowHtml: function(pin) {
    return '<div class="info_window"><h1>' + pin.name + '</h1><p class="description">' + pin.description + '</p><div><a href="' + pin.url + '">More about us</a></div></div>'
  },
  
  setBoundary: function(region) {
    this.clearBoundary();
    
  	if (region.vertices.size() > 0) {
  		var points = this.boundaryPoints(region);
  	  this.boundary = new GPolygon(points, "#090", 2, 1, "#090", 0.4);
  	  this.map.addOverlay(this.boundary);
			if (this.boundary_editing) {
  	    this.addBoundaryMarkers(region.vertices, region.vertices[region.vertices.length - 1], region.vertices[0]);
  	  }
  	}
  },
  
  enableBoundaryEditing: function() {
    var url = '/admin/regions/' + this.region.id + '/region_vertices'
    this.enableClickHandler(url);
  },
  
  addBoundaryMarkers: function(vertices, insert_after, insert_before) {
    vertices.each(function(vertex) {
      var point = this.pointFromVertex(vertex);
      var colour = 'blue'
      if (vertex == insert_after || vertex == insert_before) {
        colour = 'red'
      }
      var icon = new GIcon(G_DEFAULT_ICON, "http://www.google.com/intl/en_us/mapfiles/ms/micons/" + colour + ".png");
      
      var marker = new GMarker(point, {title: vertex.position, icon:icon});
      this.map.addOverlay(marker);
      this.boundary_markers.push(marker);
    }, this);
  },
  
  boundaryPoints: function(region) {
	  var first_vertex = region.vertices[0];
		var points = region.vertices.collect(function(vertex) {
		  return this.pointFromVertex(vertex);
		}, this);
		points.push(this.pointFromVertex(first_vertex));
    return points;
  },
  
  pointFromVertex: function(vertex) {
    return new GLatLng(vertex.lat, vertex.long);
  },
  
  clearBoundary: function() {
    if (this.boundary) {
      this.map.removeOverlay(this.boundary);
      this.boundary = null;
    }
    this.boundary_markers.each(function(marker){
      this.map.removeOverlay(marker);
    }, this);
    this.boundary_markers = [];
  },
  
  enableClickHandler: function(url) {
		GEvent.addListener(this.map, 'click', function(overlay, latlng) {
		  if (latlng) {
  			new Ajax.Request(url, 
  				{
  					asynchronous:true, 
  					evalScripts:true, 
  					method:'post',
  					parameters: 'authenticity_token=' + encodeURIComponent(authenticityToken) +
  						'&latitude=' + encodeURIComponent(latlng.lat()) +
  						'&longitude=' + encodeURIComponent(latlng.lng())
  				});
		  }
		});
  },
  
  centerOnPin: function(pin_id) {
    var marker = this.pin_markers[pin_id];
    GEvent.trigger(marker, 'click');
  }
});
