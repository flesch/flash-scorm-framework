/*
****************************************************************************************************
Extension:		Context Menu
Description:	Add functionality to the right-click context menu.
Version:		1.3
Author:			John Flesch
Modified:		December 04, 2008
****************************************************************************************************
*/
application.extend(function(){
	
	function contextMenuHandler(obj:Object, menu:ContextMenu) {
		var _length:Number = menu.customItems.length, i:Number = 0;
		for (; i<_length; i++) {
			if (menu.customItems[i].caption === "Next Slide") {
				menu.customItems[i].enabled = !application.global.isSlideLocked() && timeline.mcNextButton.enabled;
			}
			if (menu.customItems[i].caption === "Previous Slide") {
				menu.customItems[i].enabled = timeline.mcBackButton.enabled;
			}
		}
	}
	
	var mouseContextMenu:ContextMenu = new ContextMenu();
	mouseContextMenu.onSelect = contextMenuHandler;
	mouseContextMenu.hideBuiltInItems();
	mouseContextMenu.builtInItems.zoom = true;
	
	var itemNextSlide:ContextMenuItem = new ContextMenuItem("Next Slide", application.gotoNextSlide);
	var itemPreviousSlide:ContextMenuItem = new ContextMenuItem("Previous Slide", application.gotoPreviousSlide);
	var itemExportData:ContextMenuItem = new ContextMenuItem("Export Data", function(event:Object){
		vzw.external.ExternalProxy.call("JSON.stringify", [application.data], function(json:String):Void {
			System.setClipboard(escape(json));
			vzw.external.ExternalProxy.call("alert", ["Your tracking data has been copied to the clipboard."]);
		});
	});
	itemExportData.separatorBefore = true;
	
	mouseContextMenu.customItems.push(itemNextSlide, itemPreviousSlide, itemExportData);
	
	if (application.domain === "localhost" || application.domain.indexOf("pselm-utb")+1) {
		var itemViewData:ContextMenuItem = new ContextMenuItem("View Data", function(event:Object){
			vzw.external.ExternalProxy.call("JSON.stringify", [application.data, null, "\\t"], function(json:String):Void {
				System.setClipboard(unescape(json));
				vzw.external.ExternalProxy.call("alert", [unescape(json)]);
			});
		});	
		mouseContextMenu.customItems.push(itemViewData);
	}
	
	timeline.menu = mouseContextMenu;

});