package ucc.project.dialog_editor  {
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.confirm.Confirm;
	import dm.game.windows.DmWindow;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.List;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.ListEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.ClassUtils;
	import ucc.logging.Logger;
	import ucc.project.dialog_editor.canvas.Canvas;
	import ucc.project.dialog_editor.canvas.CanvasMode;
	import ucc.project.dialog_editor.node.Joint;
	import ucc.project.dialog_editor.node.JointView;
	import ucc.project.dialog_editor.node.NodeEvent;
	import ucc.project.dialog_editor.node.NodeView;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.project.dialog_editor.service.DialogService;
	import ucc.project.dialog_editor.vo.Dialog;
	import ucc.project.dialog_editor.vo.FunctionVO;
	import ucc.project.dialog_editor.vo.Condition;
	import ucc.project.dialog_editor.vo.Phrase;
	import ucc.project.dialog_editor.window.CreateNewDialogWindow;
	import ucc.project.dialog_editor.window.EditFunctionWindow;
	import ucc.project.dialog_editor.window.EditConditionWindow;
	import ucc.project.dialog_editor.window.OpenDialogWindow;
	import ucc.project.dialog_editor.window.RightsManagerWindow;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.WindowsManager;
	import ucc.util.ArrayUtil;
	import ucc.util.Delegate;
	import ucc.util.MathUtil;
	
/**
 * Dialog editor window
 *
 * @version $Id: DialogEditor.as 123 2013-05-13 07:08:24Z rytis.alekna $
 */
public class DialogEditor extends DmWindow {
	
	/** Padding */
	private static const NODE_PADDING	: Number = 10;
	
	/** Dialog canvas */
	public var dialogCanvasDO				: Canvas;

	/** New dialog button */
	public var newDialogButtonDO			: Button;

	/** Open dialog button */
	public var openDialogButtonDO			: Button;

	/** Zoom in button */
	public var zoomInButtonDO				: Button;

	/** Zoom out button */
	public var zoomOutButtonDO				: Button;

	/** Add node button */
	public var addNodeButtonDO				: Button;

	/** Conditions list */
	public var conditionsListDO				: List;

	/** Functions list */
	public var functionsListDO				: List;

	/** Add condition button */
	public var addConditionButtonDO			: Button;

	/** Remove condition button */
	public var removeConditionButtonDO		: Button;

	/** Remove node button */
	public var removeNodeButtonDO			: Button;

	/** Add function button */
	public var addFunctionButtonDO			: Button;

	/** Remove function button */
	public var removeFunctionButtonDO		: Button;

	/** Save dialog button */
	public var saveDialogButtonDO			: Button;
	
	/** Dialog title text input */
	public var dialogTitleTextInputDO		: TextInput;

	/** Save title button */
	public var saveTitleButtonDO			: Button;
	
	/** Phrase text area */
	public var phraseTextAreaDO				: TextArea;
	
	/** Dialog canvas scroll pane */
	public var dialogCanvasScrollPaneDO		: ScrollPane;
	
	/** Parent id label */
	public var parentIdLabelDO				: Label;
	
	/** Phrase id label */
	public var phraseIdLabelDO				: Label;
	
	/** Dialog id label */
	public var dialogIdLabelDO				: Label;
	
	/** Topic combobox */
	public var topicComboBoxDO				: ComboBox;
	
	/** Selector tool button */
	public var selectorToolButtonDO			: Button;

	/** Connector tool button */
	public var connectorToolButtonDO		: Button;

	/** Remove joint button */
	public var removeJointButtonDO			: Button;	
	
	/** Edit function button */
	public var editFunctionButtonDO			: Button;
	
	/** Edit condition button */
	public var editConditionButtonDO		: Button;
	
	/** Rights manager button */
	public var rightsManagerButtonDO		: Button;
	
	/** Id of dialog to load */
	protected var dialogId 					: Number;
	
	/** dialog */
	protected var dialog 					: Dialog;
	
	/** Node views */
	protected var nodeViews					: Array;
	
	/** Selected node view */
	protected var selectedNodeView			: NodeView;
	
	/** Current zoom level */
	protected var zoomLevel					: int = 0;
	
	/** Temporan ids iterator */
	protected var temporalIdsIterator		: int = -2;
	
	/** Canvas mode */
	protected var canvasMode				: CanvasMode = CanvasMode.SELECTOR;
	
	/** Current tool */
	protected var currentTool				: Button;
	
	/** Tools to modes */
	protected var toolsToModes				: Dictionary = new Dictionary();
	
	/** Tools event to listeners */
	protected var toolsEventToListeners		: Object = { };
	
	/** Connector start node */
	protected var connectorStartNode		: NodeView;
	
	/** Connector start position */
	protected var connectorStartPosition	: Array;
	
	/** Connector end node */
	protected var connectorEndNode			: NodeView;
	
	/** Root phrase (to be removed on save) */
	protected var rootPhrase				: Phrase;
	
	/**
	 * Option to label converter function
	 * @param	item
	 */
	private static function optionToLabel ( item : Object ) : String {
		var retVal : String = item.label + " ( ";
		var param : Object
		for ( var i : int = 0; i < item.params.length; i++ ) {
			param = item.params[ i ];
			retVal += param.label + " : " + param.value;
			
			if ( i < item.params.length - 1 ) {
				retVal += ", ";
			}
			
		}
		retVal += " )";
		return retVal;
	}
	
	/**
	 * Class constructor
	 */
	public function DialogEditor ( dialogId : Number = NaN ) { // , width : Number = NaN, height : Number = NaN
		this.dialogId = dialogId;
		super( null, _("Dialog editor"), 520, 380 );
		
		// temporary hook for making full screen window
		// var width : Number = WindowsManager.getInstance().getDefaultParentContainer().stage.stageWidth - 100;
		// var height : Number = WindowsManager.getInstance().getDefaultParentContainer().stage.stageHeight - 100;
		// super( null, _("Dialog editor"), width, height );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function draw () : void {
		// this.zoomInButtonDO.setStyle( "icon", ZoomInIcon );
		// this.zoomOutButtonDO.setStyle( "icon", ZoomOutIcon );
		super.draw();
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		
		this.dialogCanvasScrollPaneDO = new ScrollPane();
		this.addChild( this.dialogCanvasScrollPaneDO );
		this.dialogCanvasScrollPaneDO.x = 350;
		this.dialogCanvasScrollPaneDO.y = 70;
		this.dialogCanvasScrollPaneDO.setSize( 
			WindowsManager.getInstance().getDefaultParentContainer().stage.stageWidth - 400, 
			WindowsManager.getInstance().getDefaultParentContainer().stage.stageHeight - 100
		);
		// this.addChild( this.dialogCanvasDO );
		this.dialogCanvasScrollPaneDO.scrollDrag = true;
		
		this.dialogCanvasScrollPaneDO.source = this.dialogCanvasDO;
		
		// set up window openers
		this.openDialogButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( ClassUtils.newInstance, OpenDialogWindow, [ this, this ] ) );
		this.newDialogButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( ClassUtils.newInstance, CreateNewDialogWindow, [ this, this ] ) );
		
		this.rightsManagerButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( ClassUtils.newInstance, RightsManagerWindow, [ this ] ) );
		
		this.zoomInButtonDO.addEventListener( MouseEvent.CLICK, this.onZoomIn );
		this.zoomOutButtonDO.addEventListener( MouseEvent.CLICK, this.onZoomOut );
		
		this.saveDialogButtonDO.addEventListener( MouseEvent.CLICK, Delegate.createWithCallArgsIgnore( this.saveDialog ) );
		
		this.dialogCanvasDO.nodesLayerDO.addEventListener( NodeEvent.SELECTED, this.onNodeSelected );
		this.dialogCanvasDO.nodesLayerDO.addEventListener( NodeEvent.DESELECTED, this.onNodeDeselected );
		
		this.conditionsListDO.labelFunction = this.functionsListDO.labelFunction = optionToLabel;
		
		this.dialogCanvasScrollPaneDO.addEventListener( MouseEvent.MOUSE_DOWN, this.onCanvasMouseEvent, true );
		
		this.toolsToModes[ this.selectorToolButtonDO ] = CanvasMode.SELECTOR;
		this.toolsToModes[ this.connectorToolButtonDO ] = CanvasMode.CONNECTOR;
		
		this.redraw();
		
		for ( var tool : Object in this.toolsToModes ) {
			Button( tool ).addEventListener( MouseEvent.CLICK, this.onToolSelected );
		}
		
		this.toolsEventToListeners[ CanvasMode.SELECTOR ] = { mouseDown : this.onSelectorMouseDown, mouseMove : this.onSelectorMouseMove, mouseUp : this.onSelectorMouseUp };
		this.toolsEventToListeners[ CanvasMode.CONNECTOR ] = { mouseDown : this.onConnectorMouseDown, mouseMove : this.onConnectorMouseMove, mouseUp : this.onConnectorMouseUp };
		
		DialogEditorService.getAllTopics()
			.addResponders( this.onTopicsLoaded )
			.call();
		
		if ( !isNaN( this.dialogId ) ) {
			this.loadDialog( this.dialogId );
		}
		
	}
	
	/**
	 * On too selected
	 * @param	event
	 */
	protected function onToolSelected ( event : MouseEvent ) : void {
		for ( var tool : Object in this.toolsToModes ) {
			if ( tool == event.target ) {
				
				Button( tool ).enabled = false;
				this.canvasMode = this.toolsToModes[ tool ];
			} else {
				Button( tool ).enabled = true;
				Button( tool ).selected = false;
			}
		}
	}
	
	/**
	 * Load dialog
	 * @param	dialogId
	 */
	public function loadDialog ( dialogId : int ) : void {
		
		this.unloadDialog();
		
		this.dialogId = dialogId;
		
		DialogService.getDialogById( this.dialogId )
			.addResponders( this.onDialogLoaded )
			.call();
		
	}
	
	/**
	 * Has current dialog changed since last save?
	 * @return	true if yes
	 */
	public function hasCurrentDialogChanged () : Boolean {
		// TODO: implement
		return true;
	}
	
	/**
	 * Create new dialog
	 * @param	templateId	if templateId is provided, a copy of existing dialog will be created. If no - empty new dialog will be created.
	 */
	public function createNewDialog ( templateId : Number = NaN, newDialogName : String = null ) : void {
		
		// reseting temporal ids
		this.temporalIdsIterator = -2;
		
		this.unloadDialog();
		
		if ( templateId ) {
			DialogService.getDialogById( templateId )
				.addResponders( Delegate.create( this.onDialogLoaded, newDialogName ) )
				.call();
		} else {
			
			var newDialog : Dialog = new Dialog();
			// newDialog.phrases.push( phrase );
			
			this.onDialogLoaded( newDialog, newDialogName );
			
		}
		
	}
	
	/**
	 * Get new temporal id
	 * @return
	 */
	protected function getTemporalId () : int {
		return this.temporalIdsIterator--;
	}
	
	/**
	 * Save dialog
	 */
	public function saveDialog () : void {
		
		if ( this.dialog ) {
			
			// remove root phrase/node from dialog
			ArrayUtils.removeItem( this.dialog.phrases, this.rootPhrase );
			
			this.dialog.x_y = this.rootPhrase.x_y;
			this.dialog.topic_id = this.topicComboBoxDO.selectedItem.id;
			
			// dialog is stringified to JSON because there are some conversion back to normal object in AmfPhp problems 
			// (objects are interpreted as associative arrays)
			
			DialogEditorService.saveDialog( JSON.stringify( this.dialog ) )
				.addResponders( this.onDialogSaved )
				.call()
		}
	}
	
	
	/**
	 *	On dialog loaded
	 */
	protected function onDialogLoaded ( loadedDialog : Object, dialogNewName : String = null ) : void {
		
		this.addNodeButtonDO.enabled = true;
		
		this.addNodeButtonDO.addEventListener( MouseEvent.CLICK, this.onAddNodeButtonClick );
		
		this.dialogCanvasScrollPaneDO.addEventListener( MouseEvent.MOUSE_DOWN, this.onCanvasMouseEvent );
		
		// if it's new dialog
		if ( dialogNewName ) {
			if ( loadedDialog is Dialog ) {
				this.dialog = loadedDialog as Dialog;
			} else {
				this.dialog = Dialog.create( loadedDialog ).cleanDuplicate();
			}
			
			this.dialog.name = dialogNewName;
		
		// if it's editing of existing
		} else {
			this.dialog = Dialog.create( loadedDialog );
		}
		
		// Logger.log( this.dialog, null, this );
		
		// set last modified
		this.dialog.last_modified_by = MyManager.instance.id;
		
		if ( !this.dialog.created_by ) {
			this.dialog.created_by = MyManager.instance.id;
		}
		
		this.saveDialogButtonDO.enabled = true;
		
		this.setTitle( this.dialog.name );
		
		this.dialogIdLabelDO.text = __("#{Dialog ID}: ") + this.dialog.id;
		
		var dialogTopic : Object = ArrayUtil.getElementByPropertyValue( this.topicComboBoxDO.dataProvider.toArray(), "id", this.dialog.topic_id );
		this.topicComboBoxDO.selectedItem = dialogTopic;
		
		this.dialogTitleTextInputDO.text = this.dialog.name;
		
		this.nodeViews = [];
		
		var nodeView	: NodeView;
		
		var currentX	: Number = 30;
		
		var currentY	: Number = 30;
		
		var position : Point = new Point();
		
		// root phrase. It is just a marker of dialog tree root
		var phrase	: Phrase = new Phrase();
		phrase.id = 0;
		phrase.parent_id = -1;
		phrase.priority = 0;
		phrase.root = true;
		if ( this.dialog.x_y.length > 0 ) {
			phrase.x_y = this.dialog.x_y;
		} else {
			phrase.x_y = "10_10";
		}
		
		// phrase.subject = "npc";
		phrase.text = _("This is root node. It's text won\'t appear in dialog.");
		
		this.rootPhrase = phrase;
		
		this.dialog.phrases.unshift( phrase );
		
		// fix subject chain. In a future this should be removed when no corrupted dialogs will appear.
		this.updateTree();
		
		var item : Phrase;
		
		for each( item in this.dialog.phrases ) {
			
			nodeView = new NodeView();
			nodeView.setPhrase( item );
			
			if ( item.x_y ) {
				var positionValues : Array = item.x_y.split("_");
				position.setTo.apply( null, [ parseFloat( positionValues[0] ), parseFloat( positionValues[1] ) ] );
			} else {
				position.setTo( currentX, currentY );
				currentX += nodeView.width + NODE_PADDING;
				currentY += nodeView.height + NODE_PADDING;
			}
			
			nodeView.x = MathUtil.normalize( position.x, -2000, 2000 );
			nodeView.y = MathUtil.normalize( position.y, -2000, 2000 );
			
			item.x_y = nodeView.x + "_" + nodeView.y;
			
			nodeView.setZoomLevel( this.zoomLevel );
			
			this.nodeViews.push( nodeView );
			
			this.dialogCanvasDO.nodesLayerDO.addChild( nodeView );
			
		}
		
		// now get bounds of canvas and move all nodes to values highter than zero
		var canvasBounds	: Rectangle = this.dialogCanvasDO.nodesLayerDO.getBounds( this.dialogCanvasDO.nodesLayerDO );
		
		if ( canvasBounds.left < 0 ) {
			for each( nodeView in this.nodeViews ) {
				nodeView.x -= canvasBounds.left;
			}
		}
		
		if ( canvasBounds.top < 0 ) {
			for each( nodeView in this.nodeViews ) {
				nodeView.y -= canvasBounds.top;
			}
		}
		
		var firstLevelNodes : Array = this.getNodesByParentId( 0 );
		
		if ( ( phrase.x_y == "10_10" ) && ( firstLevelNodes.length > 0 ) ) {
			
			var rootNodeView : NodeView = this.getNodeViewById( 0 );
			
			if ( firstLevelNodes.length > 1 ) {
				
				var xSum : Number = 0;
				var ySum : Number = 0;
				
				for each( nodeView in firstLevelNodes ) {
					xSum += nodeView.x;
					ySum += nodeView.y;
				}
				
				rootNodeView.x = xSum / firstLevelNodes.length;
				rootNodeView.y = ySum / firstLevelNodes.length;
				
			} else {
				rootNodeView.x = firstLevelNodes[0].x + 15;
				rootNodeView.y = firstLevelNodes[0].y + 15;
			}
		}
		
		this.dialogTitleTextInputDO.addEventListener( Event.CHANGE, this.onDialogTitleTextInputChange );
		
		this.drawJoints();

		
		this.dialogCanvasDO.update();
		
		this.dialogCanvasScrollPaneDO.update();
		
	}
	
	protected function updateTree () : void {
		
		// find orphan nodes and fix thier subject chain too
		var orphanNodes : Array = ArrayUtil.getElementsByPropertyValue( this.dialog.phrases, "parent_id", -1 );
		for each( var orphan : Phrase in orphanNodes ) {
			this.fixSubjectChain( orphan );
		}
		
	}
	
	/**
	 * Fix subject chain
	 */
	protected function fixSubjectChain ( phrase : Phrase ) : void {
		
		var targetSubject  : String;
		
		if ( phrase.root ) {
			targetSubject = "me";
		} else {
			targetSubject = ( phrase.subject == "me" ) ? "npc" : "me";
		}
		
		var phraseChildren : Array = ArrayUtil.getElementsByPropertyValue( this.dialog.phrases, "parent_id", phrase.id );
		
		for each( var item : Phrase in phraseChildren ) {
			if ( item.subject != targetSubject ) {
				item.subject = targetSubject;
				trace( "[ucc.project.dialog_editor.DialogEditor.fixSubjectChain] fixed phrase : " + JSON.stringify( item, null, 4 ) );
			}
			
			this.fixSubjectChain( item );
		}
		
	}
	
	/**
	 * Unload dialog
	 */
	protected function unloadDialog () : void {
		this.dialogTitleTextInputDO.removeEventListener( Event.CHANGE, this.onDialogTitleTextInputChange );
		this.selectedNodeView = null;
		this.dialog = null;
		this.enableNodeControls( false );
		this.dialogCanvasDO.nodesLayerDO.removeChildren();
		this.dialogCanvasDO.drawingLayerDO.removeChildren();
		this.dialogCanvasDO.jointsLayerDO.removeChildren();
	}
	
	/**
	 * Get node view by phrase id
	 * @param	id
	 */
	public function getNodeViewById ( id : int ) : NodeView {
		for each( var nodeView : NodeView in this.nodeViews ) {
			if ( nodeView.getPhrase().id == id ) {
				return nodeView;
			}
		}
		
		return null;
		
	}
	
	/**
	 * Get nodes by parent id
	 */
	public function getNodesByParentId ( id : int ) : Array {
		
		var retVal : Array = [];
		
		for each( var nodeView : NodeView in this.nodeViews ) {
			if ( nodeView.getPhrase().parent_id == id ) {
				retVal.push( nodeView );
			}
		}		
		
		return retVal;
		
	}
	
	
	/**
	 *	On node selected
	 */
	protected function onNodeSelected ( event : NodeEvent ) : void {
		
		if ( this.selectedNodeView ) {
			this.selectedNodeView.deselect();
		}
		
		this.selectedNodeView = event.nodeView;
		
		var node : Phrase = event.nodeView.getPhrase();
		
		this.phraseTextAreaDO.text = node.text;
		
		this.functionsListDO.dataProvider = new DataProvider( node.functions );
		this.conditionsListDO.dataProvider = new DataProvider( node.conditions );
		
		this.parentIdLabelDO.text = _( "#{Parent ID}: %d", node.parent_id);
		this.phraseIdLabelDO.text = _( "#{Phrase ID}: %d", node.id);
		
		// this.functionsListDO.dataProvider = 
		
		this.enableNodeControls( !node.root );
		
		this.functionsListDO.dataProvider.addEventListener( DataChangeEvent.DATA_CHANGE, this.onOptionsDataChange );
		this.conditionsListDO.dataProvider.addEventListener( DataChangeEvent.DATA_CHANGE, this.onOptionsDataChange );
		
	}	
	
	/**
	 *	On node deselected
	 */
	protected function onNodeDeselected ( event : NodeEvent ) : void {
		this.selectedNodeView = null;
		this.enableNodeControls( false );
		this.functionsListDO.dataProvider.removeEventListener( DataChangeEvent.DATA_CHANGE, this.onOptionsDataChange );
		this.conditionsListDO.dataProvider.removeEventListener( DataChangeEvent.DATA_CHANGE, this.onOptionsDataChange );
	}
	
	/**
	 * Enable/disable node controls
	 * @param	value
	 */
	protected function enableNodeControls ( value : Boolean ) : void {
		this.removeNodeButtonDO.enabled 	= 
		this.phraseTextAreaDO.enabled 		= 
		this.conditionsListDO.enabled		=
		this.functionsListDO.enabled		= 
		this.addConditionButtonDO.enabled	= 
		this.addFunctionButtonDO.enabled	= value;
		
		if ( !value ) {
			this.phraseTextAreaDO.text = "";
			this.phraseIdLabelDO.text = _("Phrase ID");
			this.parentIdLabelDO.text = _("Parent ID");
			this.functionsListDO.removeAll();
			this.conditionsListDO.removeAll();
		}
		
		if ( value ) {
			this.functionsListDO.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.onFunctionsListItemDoubleClick );
			this.functionsListDO.addEventListener(ListEvent.ITEM_CLICK, this.onFunctionsListItemClick );
			this.addFunctionButtonDO.addEventListener( MouseEvent.CLICK, this.onAddFunctionButtonClick );
			this.removeFunctionButtonDO.addEventListener( MouseEvent.CLICK, this.onRemoveFunctionButtonClick );			
			this.editFunctionButtonDO.addEventListener( MouseEvent.CLICK, this.onFunctionsListItemDoubleClick );
			
			this.conditionsListDO.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.onConditionsListItemDoubleClick );
			this.conditionsListDO.addEventListener(ListEvent.ITEM_CLICK, this.onConditionsListItemClick );
			this.addConditionButtonDO.addEventListener( MouseEvent.CLICK, this.onAddConditionButtonClick );
			this.removeConditionButtonDO.addEventListener( MouseEvent.CLICK, this.onRemoveConditionButtonClick );
			this.editConditionButtonDO.addEventListener( MouseEvent.CLICK, this.onConditionsListItemDoubleClick );
			
			this.phraseTextAreaDO.addEventListener( Event.CHANGE, this.onPhraseTextAreaChange );
			this.removeNodeButtonDO.addEventListener( MouseEvent.CLICK, this.onRemoveNodeButtonClick );
			
		} else {
			this.functionsListDO.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.onFunctionsListItemDoubleClick );
			this.functionsListDO.removeEventListener(ListEvent.ITEM_CLICK, this.onFunctionsListItemClick );
			this.addFunctionButtonDO.removeEventListener( MouseEvent.CLICK, this.onAddFunctionButtonClick );
			this.removeFunctionButtonDO.removeEventListener( MouseEvent.CLICK, this.onRemoveFunctionButtonClick );			
			
			this.conditionsListDO.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.onConditionsListItemDoubleClick );
			this.conditionsListDO.removeEventListener(ListEvent.ITEM_CLICK, this.onConditionsListItemClick );
			this.addConditionButtonDO.removeEventListener( MouseEvent.CLICK, this.onAddConditionButtonClick );
			this.removeConditionButtonDO.removeEventListener( MouseEvent.CLICK, this.onRemoveConditionButtonClick );
			
			this.phraseTextAreaDO.removeEventListener( Event.CHANGE, this.onPhraseTextAreaChange );
			this.removeNodeButtonDO.removeEventListener( MouseEvent.CLICK, this.onRemoveNodeButtonClick );
		}
		
	}
	
	/**
	 *	On zoom in
	 */
	protected function onZoomIn ( event : MouseEvent) : void {
		
		if ( this.zoomLevel == 0 ) {
			this.zoomOutButtonDO.enabled = true;
		}
		
		if ( this.zoomLevel == 1 ) {
			this.zoomInButtonDO.enabled = false;
		}
		
		this.zoomLevel++;
		
		
		for each( var item : NodeView in this.nodeViews ) {
			item.setZoomLevel( this.zoomLevel );
		}
		
	}
	
	/**
	 *	On zoom out
	 */
	protected function onZoomOut ( event : MouseEvent) : void {
		
		if ( this.zoomLevel == 1 ) {
			this.zoomOutButtonDO.enabled = false;
		}
		
		if ( this.zoomLevel == 2 ) {
			this.zoomInButtonDO.enabled = true;
		}
		
		this.zoomLevel--;
		
		for each( var item : NodeView in this.nodeViews ) {
			item.setZoomLevel( this.zoomLevel );
		}
		
	}
	
	/**
	 *	On dialog saved
	 */
	protected function onDialogSaved ( dialogId : int ) : void {
		trace( "[ucc.project.dialog_editor.DialogEditor.onDialogSaved] dialogId : " + dialogId );
		this.loadDialog( dialogId );
	}
	
	/**
	 *	On functions ist item click
	 */
	protected function onFunctionsListItemDoubleClick ( event : Event ) : void {
		var phrase : Phrase = this.selectedNodeView.getPhrase();
		new EditFunctionWindow( phrase, this.functionsListDO.selectedItem as FunctionVO, this.functionsListDO, this );
	}
	
	/**
	 *	On add function button click
	 */
	protected function onAddFunctionButtonClick ( event : MouseEvent) : void {
		new EditFunctionWindow( this.selectedNodeView.getPhrase(), null, this.functionsListDO, this );
	}
	
	/**
	 *	On remove function button click
	 */
	protected function onRemoveFunctionButtonClick ( event : MouseEvent) : void {
		if ( this.functionsListDO.selectedItem ) {
			Confirm.show( _("You you realy want to delete selected function? If dialog wasn't saved after this function was added you will not be ablwe to undo deletion!"), _("Delete function"), Delegate.create( this.removeFunction, this.functionsListDO.selectedItem ) );
		}
	}
	
	/**
	 * Remove function
	 */
	protected function removeFunction ( functionVO : FunctionVO ) : void {
		ArrayUtils.removeItem( this.selectedNodeView.getPhrase().functions, functionVO );
		this.functionsListDO.removeItem( functionVO );
		this.selectedNodeView.getPhrase().deletedFunctions.push( functionVO );
	}
	
	/**
	 *	On function list item click
	 */
	protected function onFunctionsListItemClick ( event : ListEvent) : void {
		this.removeFunctionButtonDO.enabled = true;
		this.editFunctionButtonDO.enabled = true;
	}
	
	// ---------------------------------------------------
	
	/**
	 *	On conditions list item click
	 */
	protected function onConditionsListItemDoubleClick ( event : Event ) : void {
		var phrase : Phrase = this.selectedNodeView.getPhrase();
		new EditConditionWindow( phrase, this.conditionsListDO.selectedItem as Condition, this.conditionsListDO, this );
	}
	
	/**
	 *	On add condition button click
	 */
	protected function onAddConditionButtonClick ( event : MouseEvent) : void {
		new EditConditionWindow( this.selectedNodeView.getPhrase(), null, this.conditionsListDO, this );
	}
	
	/**
	 *	On remove condition button click
	 */
	protected function onRemoveConditionButtonClick ( event : MouseEvent) : void {
		if ( this.conditionsListDO.selectedItem ) {
			Confirm.show( _("You you realy want to delete selected condition? If dialog wasn't saved after this condition was added you will not be ablwe to undo deletion!"), _("Delete condition"), Delegate.create( this.removeCondition, this.conditionsListDO.selectedItem ) );
		}
	}
	
	/**
	 * Remove condition
	 */
	protected function removeCondition ( condition : Condition ) : void {
		ArrayUtils.removeItem( this.selectedNodeView.getPhrase().conditions, condition );
		this.conditionsListDO.removeItem( condition );
		this.selectedNodeView.getPhrase().deletedConditions.push( condition );
	}
	
	/**
	 *	On condition list item click
	 */
	protected function onConditionsListItemClick ( event : ListEvent ) : void {
		this.removeConditionButtonDO.enabled = true;
		this.editConditionButtonDO.enabled = true;
	}	
	
	/**
	 *	On add node button click
	 */
	protected function onAddNodeButtonClick ( event : MouseEvent) : void {
		
		var nodeView : NodeView = new NodeView();
		
		var phrase: Phrase = new Phrase();
		
		var nodeX : Number;
		
		var nodeY : Number;
		
		phrase.id = this.getTemporalId();
		
		if ( this.selectedNodeView ) {
			
			var selectedPhrase : Phrase = this.selectedNodeView.getPhrase();
			
			phrase.subject = ( selectedPhrase.subject == "me" ) ? "npc" : "me";
			
			phrase.parent_id = selectedPhrase.id;
			
			nodeX = this.selectedNodeView.x + 100;
			nodeY = this.selectedNodeView.y + 100;
			
		} else {
			this.selectedNodeView = this.getNodeViewById( 0 );
			this.selectedNodeView.select();
			phrase.subject = "me";
			phrase.parent_id = 0;
			nodeX = this.dialogCanvasDO.nodesLayerDO.width;
			nodeY = this.dialogCanvasDO.nodesLayerDO.height;
		}
		
		phrase.priority = 0;
		
		phrase.x_y = String( nodeX ) + "_" + String( nodeY );
		nodeView.x = nodeX;
		nodeView.y = nodeY;
		
		nodeView.setPhrase( phrase );
		
		nodeView.setZoomLevel( this.zoomLevel );
		
		this.dialog.phrases.push( phrase );
		
		if ( this.selectedNodeView ) {
			
			var joint : JointView = new JointView();
			joint.setStartNodeView( this.selectedNodeView );
			joint.setEndNodeView( nodeView );
			this.dialogCanvasDO.jointsLayerDO.addChild( joint );
			
		}
		
		this.dialogCanvasDO.nodesLayerDO.addChild( nodeView );
		
		this.dialogCanvasScrollPaneDO.update();
		this.dialogCanvasScrollPaneDO.horizontalScrollPosition = nodeX + nodeView.width;
		this.dialogCanvasScrollPaneDO.verticalScrollPosition = nodeY + nodeView.height;
		this.dialogCanvasScrollPaneDO.update();
		
	}
	
	/**
	 *	On dialog canvas mouse down
	 */
	protected function onCanvasMouseEvent ( event : MouseEvent ) : void {
		this.toolsEventToListeners[ this.canvasMode ][ event.type ]( event );
	}
	
	/**
	 *	On dialog canvas mouse down
	 */
	protected function onSelectorMouseDown ( event : MouseEvent) : void {
		
		this.dialogCanvasScrollPaneDO.update();
		
		if ( event.target is NodeView ) {
			var nodeView : NodeView = event.target as NodeView;
			
			if ( !nodeView.isSelected() ) {
				nodeView.select();
			}
			
			nodeView.startDrag( false, new Rectangle( 0, 0, 2000, 2000 ) );
			this.stage.addEventListener( MouseEvent.MOUSE_MOVE, this.onSelectorMouseMove, true );
			this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onSelectorMouseUp, true );
			event.stopImmediatePropagation();
			
			
		} else {
			if ( this.selectedNodeView ) {
				this.selectedNodeView.deselect();
			}
		}
		
	}
	
	/**
	 * On dialog canvas mouse move
	 */
	protected function onSelectorMouseMove ( event : MouseEvent) : void {
		
		if ( event.buttonDown && this.selectedNodeView ) {
			this.selectedNodeView.updateJoints();
			
			// this.dialogCanvasScrollPaneDO.horizontalScrollPosition = this.selectedNodeView.x;
			// this.dialogCanvasScrollPaneDO.verticalScrollPosition = this.selectedNodeView.y;
			this.dialogCanvasDO.update();
			this.dialogCanvasScrollPaneDO.update();
			
		}
		
	}
	
	/**
	 * On dialgo canvas mouse up
	 */
	protected function onSelectorMouseUp ( event : MouseEvent) : void {
		
		var nodeView : NodeView = this.selectedNodeView;
		
		nodeView.stopDrag();
		nodeView.getPhrase().x_y = String( nodeView.x ) + "_" + String( nodeView.y );
		
		this.stage.removeEventListener( MouseEvent.MOUSE_MOVE, this.onSelectorMouseMove, true );
		this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.onSelectorMouseUp, true );
		this.dialogCanvasScrollPaneDO.update();
	}
	
	/**
	 *	On dialog canvas mouse down
	 */
	protected function onConnectorMouseDown ( event : MouseEvent) : void {
		
		if ( event.target is NodeView ) {
			
			this.connectorStartNode = event.target as NodeView;
			
			this.connectorStartPosition = [ this.connectorStartNode.x + JointView.OFFSET, this.connectorStartNode.y + JointView.OFFSET ];
			
			this.dialogCanvasScrollPaneDO.addEventListener( MouseEvent.MOUSE_MOVE, this.onConnectorMouseMove, true );
			this.dialogCanvasScrollPaneDO.addEventListener( MouseEvent.MOUSE_UP, this.onConnectorMouseUp );
			
			
		}
		
	}
	
	/**
	 * On dialog canvas mouse move
	 */
	protected function onConnectorMouseMove ( event : MouseEvent) : void {
		
		this.dialogCanvasDO.drawingLayerDO.graphics.clear();
		this.dialogCanvasDO.drawingLayerDO.graphics.lineStyle( 4, 0xFFFF00 );
		this.dialogCanvasDO.drawingLayerDO.graphics.moveTo.apply( null, this.connectorStartPosition );
		var localPoint : Point = this.dialogCanvasDO.drawingLayerDO.globalToLocal( new Point( event.stageX, event.stageY ) );
		this.dialogCanvasDO.drawingLayerDO.graphics.lineTo( localPoint.x, localPoint.y );
		
		if ( event.target is NodeView ) {
			
			this.connectorEndNode = event.target as NodeView;
			
			if ( this.canJoin( this.connectorStartNode, this.connectorEndNode ) ) {
				NodeView( this.connectorEndNode ).setValid();
			} else {
				NodeView( this.connectorEndNode ).setInvalid();
			}
		} else if ( this.connectorEndNode ) {
			this.connectorEndNode.setNeutral();
			this.connectorEndNode = null;
		}
		
	}
	
	/**
	 * On dialgo canvas mouse up
	 */
	protected function onConnectorMouseUp ( event : MouseEvent) : void {
		
		this.dialogCanvasDO.drawingLayerDO.graphics.clear();
		this.dialogCanvasScrollPaneDO.removeEventListener( MouseEvent.MOUSE_MOVE, this.onConnectorMouseMove, true );
		this.dialogCanvasScrollPaneDO.removeEventListener( MouseEvent.MOUSE_UP, this.onConnectorMouseUp );
		this.dialogCanvasScrollPaneDO.update();		
		
		if ( event.target is NodeView ) {
			
			this.connectorEndNode = event.target as NodeView;
			
			this.connectorEndNode.setNeutral();
			this.connectorStartNode.setNeutral();
			
			if ( this.canJoin( this.connectorStartNode, this.connectorEndNode ) ) {
				this.joinNodes( this.connectorStartNode, this.connectorEndNode );
			}
			
			this.connectorStartNode = null;
			this.connectorEndNode = null;
			
		}
		
	}	
	
	/**
	 * Join nodes
	 */
	protected function joinNodes ( nodeView1 : NodeView, nodeView2 : NodeView ) : void {
		
	}
	
	/**
	 * Can given two nodes join?
	 */
	protected function canJoin ( nodeView1 : NodeView, nodeView2 : NodeView ) : Boolean {
		
		if ( nodeView1 == nodeView2 ) {
			return false;
		}
		
		if ( ArrayUtils.containsAnyEquality( nodeView1.getJoints(), nodeView2.getJoints() ) ) {
			// Alert.show( _("Phrases are already connected!"), _("Dialog editor") );
			return false;
		}
		
		return true;
		
	}
	
	/**
	 * Draw joints
	 */
	protected function drawJoints () : void {
		
		var phrase 		: Phrase;
		
		var jointView	: JointView;
		
		var parentNode	: NodeView;
		
		for each( var item : NodeView in this.nodeViews ) {
			
			phrase = item.getPhrase();
			
			if ( !isNaN( phrase.parent_id ) && ( phrase.parent_id != -1 ) ) {
				
				parentNode = this.getNodeViewById( phrase.parent_id );
				
				if ( parentNode ) {
					
					jointView = new JointView();
					
					// parent node is always start node!
					jointView.setStartNodeView( parentNode );
					jointView.setEndNodeView( item );
					
					this.dialogCanvasDO.jointsLayerDO.addChild( jointView );
					
				} else {
					trace( "[ucc.project.dialog_editor.DialogEditor.drawJoints] : parent node not found for phrase id: " + phrase.id );
				}
				
			}
			
		}
		
	}
	
	/**
	 *	On phrase text change
	 */
	protected function onPhraseTextAreaChange ( event : Event) : void {
		if ( this.selectedNodeView ) {
			this.selectedNodeView.getPhrase().text = this.phraseTextAreaDO.text;
			this.selectedNodeView.invalidate();
		}
	}
	
	/**
	 *	On dialog title text input change
	 */
	protected function onDialogTitleTextInputChange ( event : Event) : void {
		if ( this.dialog ) {
			this.dialog.name = this.dialogTitleTextInputDO.text;
		}
	}
	
	/**
	 *	On remove node button click
	 */
	protected function onRemoveNodeButtonClick ( event : MouseEvent) : void {
		if ( this.selectedNodeView ) {
			
			var phrase : Phrase = this.selectedNodeView.getPhrase();
			
			if ( phrase.id == 0 ) {
				Alert.show( _("You can't delete root phrase! Edit it instead"), _( "Dialog Editor" ) );
			} else {
				Confirm.show( _("Do you realy want to delete selected phrase?"), _( "Dialog editor" ), Delegate.create( this.onNodeDeletionConfirmed, this.selectedNodeView ) );
			}
			
		}
	}
	
	/**
	 * On node deletion confirmed
	 */
	protected function onNodeDeletionConfirmed ( nodeView : NodeView ) : void {
		
		var phrase : Phrase = nodeView.getPhrase();
		
		for each( var jointView : JointView in nodeView.getJoints() ) {
			jointView.destroy();
		}
		
		ArrayUtils.removeItem( this.dialog.phrases, phrase );
		
		// if phrase was saved before
		if ( phrase.id > 0 ) {
			this.dialog.deletedPhrases.push( phrase );
		}
		
		this.dialogCanvasDO.nodesLayerDO.removeChild( nodeView );
		
		this.selectedNodeView = null;
		
	}
	
	/**
	 *	On options data change (update node view)
	 */
	protected function onOptionsDataChange ( event : DataChangeEvent) : void {
		if ( this.selectedNodeView ) {
			this.selectedNodeView.invalidate();
		}
	}
	
	
	/**
	 *	On tpics loaded
	 */
	protected function onTopicsLoaded ( response : Array ) : void {
		
		this.topicComboBoxDO.dataProvider = new DataProvider( response );
		
		if ( this.dialog ) {
			var item : Object = ArrayUtil.getElementByPropertyValue( response, "id", this.dialog.topic_id );
			this.topicComboBoxDO.selectedItem = item;
		}
		
	}
	
}
	
}