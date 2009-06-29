/*****************************************************************
Copyright (c) 2008 Patrick Avella
http://javascriptwindowlibrary.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*****************************************************************/

/*******
   Version 0.2 
 ********/

// Some globals you can change
var show_close_button=1;
var show_maximize_button=1;
var min_win_size= 21;
var inner_frame_offset=40; // size of title + statbar
var mydow_default_w= 400;
var mydow_default_h= 300;


// We store all window runtime info a hash of hashes
// where the top level key is the window handle
var myhash = new Hash();

var mydows= new Hash();

// Things you can watch. Dragxoffset is used internally
// by resize
var mouse= {"x": 0, "y": 0, "delta_x": 0, "delta_y": 0 };
var dragxoffset=0;
var dragyoffset=0;

var ie=0;


// some classes to describe how things should look
var mydow_class_frame= {
	'position': 'absolute',
	'top': '10px',
	'left': '10px',
	'height': 'auto',
	'background': '#0000A0',
	'border': 'solid 1px black',
	'padding': '1px',
	'width':  mydow_default_w+'px',
	'height':  mydow_default_h+'px',
	'overflow': 'hidden',
	'zIndex': 4,
	'MozBorderRadius' : '.5em'
	}



var mydow_class_title= {
	'padding' : '2px',
	'text-align ': 'left',
	'background' : 'url(/images/grad.gif) #0000A0',
	'font' : ' bold 10px sans-serif',
	'height' : '15px',
	'color' : '#FFFFFF',
	'border' : '1px solid #0000A0',
	'white-space' : 'nowrap',
	'overflow' : 'hidden',
	'MozBorderRadius' : '.5em .5em 0em 0em'
	};

var mydow_class_body= {
	'border' : '1px solid black',
	'border-bottom' : 'none',
	'background' : '#FFFFFF',
	'font' : '16px sans-serif',
	'color' : '#000000',
	'overflow' : 'auto',
	'height' : 'auto'
	};

var mydow_class_statbar= {
	'text-align' : 'left',
	'background' : 'lightgrey',
	'color' : '#505050',
	'height' : '15px',
	'line-height' : '15px',
	'font' : '10px sans-serif',
	'border' : '1px solid black',
	'white-space' : 'nowrap',
	'overflow' : 'hidden',
	'MozBorderRadius' : '0em 0em .5em .5em'
	};



// ------------------------------


// given the handle, load an ajax response into a window
function mydow_load(handle, url) {
    new Ajax.Updater(handle+'_body', url, { method: 'get', evalScripts: true });
	}

// lowers all windows and sets opacity
function lower_all() {
	mydows.each(function(obj) {
		$(obj.key+"_frame").setStyle( {
			"zIndex": 1
			});
		$(obj.key+"_frame").setOpacity(.5);
		});
	}



function mydows_init() {
	if(navigator.userAgent.indexOf("MSIE") > -1) {
		ie=true;
		mydow_class_title.height=20;
		ie=-2;
		}

	document.observe('mousemove', function(e) { 
		mouse.delta_x= e.pointerX() - mouse.x;
		mouse.delta_y= e.pointerY() - mouse.y;
		mouse.x=e.pointerX();
		mouse.y=e.pointerY();
		mydows_drag(); // if there's anything draggable
		} );

	document.observe('mousedown', function(e) { 
		var element = Event.element(e);
		if (element.readAttribute("id")) if (element.readAttribute("id").endsWith("_frame")) {
			mydows_stop_select(true);
			}
		} );

	document.observe('mouseup', function(e) { 
		mydows.each( function(h) {
			mydow_property(h.key, "drag", 0);
			mydow_property(h.key, "resize", 0);
			$(h.key+"_title").setStyle({"cursor": "default"}); 
			mydows_stop_select(false);
			});
		});


	}

// This function handles all resizing and dragging
// called internally onmousemove
function mydows_drag() {

	mydows.each(function(obj){


		if(obj.value.get("drag") == 1) {
			$(obj.key+"_frame").setStyle( {
				"top": mouse.y-dragyoffset > -1 ? mouse.y-dragyoffset : 0 ,
				"left": mouse.x-dragxoffset > -1 ? mouse.x-dragxoffset : 0
				});
			}

		// E RESIZE
		else if(obj.value.get("resize") == "e-resize") {
			var new_width=mouse.x-$(obj.key+"_frame").cumulativeOffset().left;
			$(obj.key+"_frame").setStyle( {
				"width":  new_width > min_win_size ? new_width : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie+ie : min_win_size-2
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}

		// W RESIZE
		else if(obj.value.get("resize") == "w-resize") {
			var new_width=obj.value.get("resize_anchor_x")-mouse.x;
			$(obj.key+"_frame").setStyle( {
				"left" : mouse.x,
				"width":  new_width > min_win_size ? new_width : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}

		// N RESIZE
		else if(obj.value.get("resize") == "n-resize") {
			var new_height=obj.value.get("resize_anchor_y")-mouse.y;
			$(obj.key+"_frame").setStyle( {
				"top" : mouse.y,
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			}

		// NW RESIZE
		else if(obj.value.get("resize") == "nw-resize") {
			var new_width=obj.value.get("resize_anchor_x")-mouse.x;
			var new_height=obj.value.get("resize_anchor_y")-mouse.y;
			$(obj.key+"_frame").setStyle( {
				"top" : mouse.y,
				"left" : mouse.x,
				"width":  new_width > min_win_size ? new_width : min_win_size,
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2,
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}

		// NE RESIZE
		else if(obj.value.get("resize") == "ne-resize") {
			var new_width=mouse.x-$(obj.key+"_frame").cumulativeOffset().left;
			var new_height=obj.value.get("resize_anchor_y")-mouse.y;
			$(obj.key+"_frame").setStyle( {
				"top" : mouse.y,
				"width":  new_width > min_win_size ? new_width : min_win_size,
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2,
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}


		// SE RESIZE
		else if(obj.value.get("resize") == "se-resize") {
			var new_width=mouse.x-$(obj.key+"_frame").cumulativeOffset().left;
			var new_height=mouse.y-$(obj.key+"_frame").cumulativeOffset().top;
			$(obj.key+"_frame").setStyle( {
				"width":  new_width > min_win_size ? new_width : min_win_size,
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2,
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}

		// SW RESIZE
		else if(obj.value.get("resize") == "sw-resize") {
			var new_width=obj.value.get("resize_anchor_x")-mouse.x;
			var new_height=mouse.y-$(obj.key+"_frame").cumulativeOffset().top;
			$(obj.key+"_frame").setStyle( {
				"left" : mouse.x,
				"width":  new_width > min_win_size ? new_width : min_win_size,
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2,
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			$(obj.key+"_statbar").setStyle({"width": $(obj.key+"_body").getWidth()-2-ie});
			}

		// S RESIZE
		else if(obj.value.get("resize") == "s-resize") {
			var new_height=mouse.y-$(obj.key+"_frame").cumulativeOffset().top;
			$(obj.key+"_frame").setStyle( {
				"height":  new_height > min_win_size ? new_height : min_win_size
				});
			$(obj.key+"_body").setStyle( {
				"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
				});
			}


		});
	}



function mydows_stop_select(state) {
	if(state) { // on
		document.onselectstart=new Function('return false');
		document.onmousedown=function(e){return false;};
		document.onclick=function(){return true;};
		}
	else { // off
		document.onselectstart=new Function("return true");
		if (window.sidebar) {
			document.onmousedown=function() {return true;};
			}
		}
	}

function kill_mydow(handle) {
	$(handle+"_frame").remove();
	mydows.unset(handle);
	}

// This function is what you call with a handle name to create
// a new window. 
function new_mydow(handle) {
	if(!mydows.get(handle)) {
		// A frame is the top level of the window
		var myframe= new Element("div", { "id": handle+"_frame", "class": "mydow_frame" });
		myframe.setStyle(mydow_class_frame);


		// Create Title Bar with optional buttons
		var mytitle= new Element("div", { "id": handle+"_title", "class": "mydow_title" }).update(
			"<span id='"+handle+"_title_msg'>"+handle+"</span>"
			);
		mytitle.setStyle(mydow_class_title);

		if(show_maximize_button) {
			var mymaximizebutton= new Element("img", { "id": handle+"_maximizebutton", 
				"align": "right",
				"src": "/images/maximize0.gif", 
				"onmouseover": "this.src='/images/maximize1.gif';",
				"onmouseout" : "this.src='/images/maximize0.gif';"
				});
			mytitle.insert({"top": mymaximizebutton });
			}

		if(show_close_button) {
			var myxbutton= new Element("img", { "id": handle+"_xbutton", 
				"align": "right",
				"src": "/images/close0.gif", 
				"onmouseover": "this.src='/images/close1.gif';",
				"onmouseout" : "this.src='/images/close0.gif';"
				});
			mytitle.insert({"top": myxbutton });
			}

		// Create the main body of content
		var mybody = new Element("div", { "id": handle+"_body" , "class": "mydow_body"  }).update("&nbsp;");
		mybody.setStyle(mydow_class_body);

		//Create a cool status bar at the bottom
		var mystatbar = new Element("div", { "id": handle+"_statbar" , "class": "mydow_statbar"  });
		mystatbar.setStyle(mydow_class_statbar);

		// From here everything is appended
		myframe.insert({"top": mystatbar });
		myframe.insert({"top": mybody });
		myframe.insert({"top": mytitle});
		$(document.body).insert({"top": myframe});

		// put it somewhere in the middle
		mydow_set_position(handle,
			document.viewport.getScrollOffsets().left+300,
			document.viewport.getScrollOffsets().top+200,
			mydow_default_w,
			mydow_default_h
			);

		// let it pop in front
		lower_all();

		// Set all default properties of the window

		mydows.set(handle, new Hash({
			"resize": 0,
			"resize_anchor_x": 0,
			"resize_anchor_y": 0,
			"drag": 0,
			"maximized": 0,
			"old_coords": { 'x':0, 'y':0, 'w':0, 'h':0 }
			}) );


		// DRAGGABLE TITLE BAR
		mytitle.observe('mousedown', function(e) { 
			// We need to find our offset so it looks and feels natural
			dragxoffset= mouse.x-myframe.cumulativeOffset().left; 
			dragyoffset= mouse.y-myframe.cumulativeOffset().top ; 
			mytitle.setStyle({"cursor": "move"}) ; 
			mydow_property(handle, "drag", 1);
			mydows_stop_select(true);
			});

		// Prevent text selection over statbar
		mystatbar.observe('mousedown', function(e) { 
			mydows_stop_select(true);
			});

		myframe.observe('mousedown', function(e) { 
			// Resize
			mydow_property(handle, "resize", myframe.getStyle("cursor"));
			mydow_property(handle, "resize_anchor_x", myframe.getWidth()+myframe.cumulativeOffset().left);
			mydow_property(handle, "resize_anchor_y", myframe.getHeight()+myframe.cumulativeOffset().top);
			// Z index
			lower_all();
			myframe.setStyle( {
				"zIndex": 3
				});
			myframe.setOpacity(50);
			});

//		mybody.observe('mousedown', function(e) {
//			mydows_stop_select(false);
//			});

		// Close Button
		if(show_close_button) myxbutton.observe('click', function(e) { 
			myframe.hide();
			//mydows.unset(handle);
			} );

		// Maximize Button
		if(show_maximize_button) mymaximizebutton.observe('click', function(e) { 
			if(mydows.get(handle).get("maximized")) { // return to size
				mydow_property(handle, "maximized", 0);
				myframe.setStyle({
					'top': mydows.get(handle).get("old_coords").y,
					'left': mydows.get(handle).get("old_coords").x,
					'width': mydows.get(handle).get("old_coords").w,
					'height': mydows.get(handle).get("old_coords").h
					});
				mybody.setStyle( {
					"width":  mydows.get(handle).get("old_coords").w-2 > min_win_size-2 ? mydows.get(handle).get("old_coords").w-2+ie : min_win_size-2,
					"height":  mydows.get(handle).get("old_coords").h-inner_frame_offset > min_win_size-inner_frame_offset ? mydows.get(handle).get("old_coords").h-inner_frame_offset : min_win_size-inner_frame_offset
					});
				mystatbar.setStyle({"width": mybody.getWidth()-2-ie});
				}
			else {
				window.scroll(0,0);
				mydow_property(handle, "maximized", 1);
				mydows.get(handle).get("old_coords").x= myframe.getStyle("left");
				mydows.get(handle).get("old_coords").y= myframe.getStyle("top");
				mydows.get(handle).get("old_coords").w= myframe.getWidth();
				mydows.get(handle).get("old_coords").h= myframe.getHeight();
				var new_width= $(document.body).getWidth()+ie*20; // 4 makes up for 2px border on frame
				var new_height= $(document.body).getHeight();
				myframe.setStyle({
					'top': 5-2*ie,
					'left': 5-2*ie,
					'width': new_width,
					'height': new_height
					});
				mybody.setStyle( {
					"width":  new_width-2+ie > min_win_size-2 ? new_width-2+ie : min_win_size-2,
					"height":  new_height-inner_frame_offset > min_win_size-inner_frame_offset ? new_height-inner_frame_offset : min_win_size-inner_frame_offset
					});
				mystatbar.setStyle({"width": mybody.getWidth()-2-ie});
				}
			} );


		// Resizer
		myframe.observe('mousemove', function(e) { 
			var t_win= { x: myframe.cumulativeOffset().left, y:myframe.cumulativeOffset().top }
			//right edge
			if(mouse.x >= t_win.x+myframe.getWidth()-10 
				&& mouse.y >= t_win.y+10 && mouse.y <= t_win.y+myframe.getHeight()-10) { 
				myframe.setStyle({'cursor' : 'e-resize'});
				}
			//bottom edge
			else if(mouse.x >= t_win.x+10 && mouse.x <= t_win.x+myframe.getWidth()-10
				&& mouse.y >= t_win.y+myframe.getHeight()-10 ) { 
				myframe.setStyle({'cursor' : 's-resize'});
				}
			//left edge
			else if(mouse.x <= t_win.x+10
				&& mouse.y >= t_win.y+10 && mouse.y <= t_win.y+myframe.getHeight()-10) { 
				myframe.setStyle({'cursor' : 'w-resize'});
				}
			//top edge
			else if(mouse.x <= t_win.x+myframe.getWidth()-10 && mouse.x >= t_win.x+10
				&& mouse.y <= t_win.y+10) { 
				myframe.setStyle({'cursor' : 'n-resize'});
				}
			//south east
			else if(mouse.x > t_win.x+myframe.getWidth()-10
				&& mouse.y > t_win.y+myframe.getHeight()-10) { 
				myframe.setStyle({'cursor' : 'se-resize'});
				}
			//north east
			else if(mouse.x > t_win.x+myframe.getWidth()-10
				&& mouse.y < t_win.y+10) { 
				myframe.setStyle({'cursor' : 'ne-resize'});
				}
			//south West
			else if(mouse.x < t_win.x+10
				&& mouse.y > t_win.y+myframe.getHeight()-10) { 
				myframe.setStyle({'cursor' : 'sw-resize'});
				}
			//north West
			else if(mouse.x < t_win.x+10
				&& mouse.y < t_win.y+10) { 
				myframe.setStyle({'cursor' : 'nw-resize'});
				}

			else {
				myframe.setStyle({'cursor' : 'default'});
				mydow_property(handle, "resize", 0);
				}
			});


		}

	// return useful information
	return {
		'handle' : handle,
		'body': handle+"_body",
		'frame': handle+"_frame",
		'title': handle+"_title",		
		'title_msg': handle+"_title_msg",		
		'statbar': handle+"_statbar"
		};
	}

function mydow_open(user_id, handle){
  if(!mydows.get(handle)) {
    new_mydow(handle);
    mydow_load(handle, "/student_louge/chanel_chat_content?user_id=" + user_id);
  }else{
    $(handle+"_frame").show();
  }
}

function mydow_property(handle, prop, val) {
	var properties= mydows.get(handle); 
	properties.set(prop, val);
	mydows.set(handle,properties);
	}


function mydow_set_position(handle, x, y, w, h) {
	$(handle+"_frame").setStyle({
		'left': x,
		'top' : y,
		'width' : w,
		'height': h
		});
	$(handle+"_body").setStyle( {
		"width":  w-2 > min_win_size-2 ? w-2+ie : min_win_size-2,
		"height":  h-inner_frame_offset > min_win_size-inner_frame_offset ? h-inner_frame_offset : min_win_size-inner_frame_offset
		});
	$(handle+"_statbar").setStyle({"width": $(handle+"_body").getWidth()-2-ie});
	}

function mydow_dimensions(handle) {
	var result= { 'x':0,'y':0,'w':0,'h':0 };
	result.x= $(handle+"_frame").cumulativeOffset().x;
	result.y= $(handle+"_frame").cumulativeOffset().y;
	result.w= $(handle+"_frame").getWidth();
	result.h= $(handle+"_frame").getHeight();
	return results;
	}





