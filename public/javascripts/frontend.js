/*
*UI script
*By Vu Nguyen
*Data-Fountain Inc.
*/

/* drop down menu 
var DropDownMenu = Class.create();
 
DropDownMenu.prototype = {
 
 initialize: function(menuElement) {
	menuElement.childElements().each(function(node){
		// if there is a submenu
		var submenu = $A(node.getElementsByTagName("ul")).first();
		if(submenu != null){
			// make sub-menu invisible
			Element.extend(submenu).setStyle({display: 'none'});
			// toggle the visibility of the submenu
			node.onmouseover = node.onmouseout = function(){
				Element.toggle(submenu);
			}
		}
	});
}
 
};*/

/* dropdown menu with click*/
function showlayer(layer){
	var myLayer=document.getElementById(layer);
	if(myLayer.style.display=="none" || myLayer.style.display==""){
		myLayer.style.display="block";
	} else { 
		myLayer.style.display="none";
		}
}