package dm.game.windows.dialogviewer {

import dm.game.conditions.ConditionChecker;
import dm.game.functions.FunctionExecutor;
import dm.game.managers.MyManager;
import dm.game.windows.alert.Alert;
import dm.game.windows.DmWindow;
import fl.controls.Button;
import fl.controls.Label;
import fl.controls.ProgressBar;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.setTimeout;
import ucc.project.dialog_editor.DialogEditor;
import ucc.project.dialog_editor.service.DialogEditorService;
import ucc.ui.style.DynamicStyleManager;
import utils.AMFPHP;

/**
 * Dialog viewer
 * @version $Id: DialogViewer.as 205 2013-08-29 07:02:08Z rytis.alekna $
 */
[Single]
[Updatable]
public class DialogViewer extends DmWindow {
	
	/** Vote up button */
	public var voteUpButtonDO : Button;
	
	/** Vote down button */
	public var voteDownButtonDO : Button;
	
	/** Edit dialog button */
	public var editDialogButtonDO : Button;
	
	/** Rating progress bar */
	public var ratingProgressBarDO : ProgressBar;
	
	/** Positive rating label */
	public var positiveRatingLabelDO		: Label;

	/** Negative rating label */
	public var negativeRatingLabelDO		: Label;	
	
	private const DIALOG_VIEWER_WIDTH : Number = 520;
	
	private const CONTENT_AREA_MARGIN_TOP : Number = 35;
	
	private const BG_MARGIN_BOT : Number = 20;
	
	private const CONTENT_AREA_MARGIN : Number = 10;
	
	private const NPC_TEXT_MARGIN : Number = 10;
	
	private const MAX_NPC_TEXT_HEIGHT : Number = 280;
	
	private var _npcText_tf : TextField;
	
	private var _currentOptions : Array = new Array();
	
	private var _phrases : Array;
	
	private var contentAreaBg : Sprite;
	
	private var _initializing : Boolean = false;
	
	/** dialog id */
	protected var dialogId 	: int;
	
	/** openingExplicitNode */
	protected var openingExplicitNode	: Boolean;
	
	/**
	 * Class constructor
	 */
	public function DialogViewer( parent : DisplayObjectContainer, dialogId : int ) {
		this.dialogId = dialogId;
		super( parent, _("Dialog") ); // DIALOG_VIEWER_WIDTH, 400
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize() : void {
		this.voteUpButtonDO.addEventListener(Event.CHANGE, this.onVoteButtonClick );
		this.voteDownButtonDO.addEventListener( Event.CHANGE, this.onVoteButtonClick );
		this.editDialogButtonDO.addEventListener( MouseEvent.CLICK, this.onEditDialogButtonClick );
		this.editDialogButtonDO.visible = false;
		this.renderDialog();
	}
	
	/**
	 * Render dialog
	 */
	protected function renderDialog () : void {
		this._initializing = true;
		
		this.editDialogButtonDO.visible = false;
		
		var amfphp : AMFPHP = new AMFPHP( onDialogLoaded );
		amfphp.xcall( "dm.Dialog.getDialogById", dialogId );
		
		DialogEditorService.getDialogRating( this.dialogId, MyManager.instance.avatar.id )
			.addResponders( this.onDialogRatingLoaded )
			.call();
		
		DialogEditorService.hasPermisionToDialog( this.dialogId, MyManager.instance.id )
			.addResponders( this.onDialogPermissionLoaded, this.onDialogPermissionLoaded )
			.call();
			
	}
	
	
	/**
	 *	On dialog rating loaded
	 * 	@param	response {int positive, int negative}
	 */
	protected function onDialogRatingLoaded ( response : Object ) : void {
		
		var ratingSum 		: int = parseInt( response.positive ) + parseInt( response.negative );
		var maxRating		: int = ( ratingSum == 0 ) ? 2 : ratingSum;
		var positiveRating 	: int = ( ratingSum == 0 ) ? 1 : response.positive;
		
		this.ratingProgressBarDO.setProgress( positiveRating, maxRating );
		this.positiveRatingLabelDO.text = response.positive;
		this.negativeRatingLabelDO.text = response.negative;
		
		if ( response.own ) {
			this.voteDownButtonDO.selected = !( this.voteUpButtonDO.selected = ( response.own == "Y" ) );
		}
	}
	
	/**
	 *	On vote up button click
	 */
	protected function onVoteButtonClick ( event : Event ) : void {
		
		if ( Button( event.target ).selected ) {
			var vote : String = ( event.target == this.voteUpButtonDO ) ? "Y" : "N";
			DialogEditorService.addVoteForDialog( this.dialogId, MyManager.instance.avatar.id, vote )
				.addResponders( this.onDialogRatingLoaded )
				.call();
		} else {
			DialogEditorService.removeVoteFromDialog( this.dialogId, MyManager.instance.avatar.id )
				.addResponders( this.onDialogRatingLoaded )
				.call();
		}
		
	}
	
	
	/**
	 *	On dialog permission loaded
	 */
	protected function onDialogPermissionLoaded ( response : Boolean ) : void {
		this.editDialogButtonDO.visible = response;
	}
	
	/**
	 *	On edit dialog button click
	 */
	protected function onEditDialogButtonClick ( event : MouseEvent ) : void {
		new DialogEditor(this.dialogId);
	}
	
	/**
	 * On dialog loaded
	 */
	private function onDialogLoaded( response : Object ) : void {
		_initializing = false;
		
		_phrases = response.phrases;
		this.openNode( 0 );
	}
	
	public function openExplicitNode ( nodeId : int ) : void {
		this.openingExplicitNode = true;
		this.openNode( nodeId );
	}
	
	protected function openNode ( nodeId : int ) : void {
		var entryPoints : Array = getPhraseChildren( nodeId );
		
		if ( entryPoints.length == 0 ) {
			throw( new Error( "Dialog doesn't have entry points (phrases with parent_id=" + nodeId + ")." ) );
			return;
		}
		
		checkNpcPhrases( entryPoints );
	}
	
	public function checkNpcPhrases( phrases : Array ) : void {
		for each ( var phrase : Object in phrases ) {
			if ( phrase.conditions.length == 0 ) {
				display( phrase );
				return;
			}
		}
		
		var currentPhrase : int = 0;
		var checker : ConditionChecker = new ConditionChecker;
		checker.checkConditions( phrases[ currentPhrase ].conditions, onPhraseCheck );
		
		function onPhraseCheck( result : Boolean ) : void {
			if ( result ) {
				display( phrases[ currentPhrase ] );
				return;
			} else {
				currentPhrase++;
				
				if ( currentPhrase > phrases.length - 1 ) {
					// TODO; act a little bit more politely there instead of throwing exception
					throw( new Error( "dm.game.windows.dialogviewer.DialogViewer.checkNpcPhrases().onPhraseCheck() : None of NPC phrases are available, bad dialog edition." ) );
					return;
				}
				checker.checkConditions( phrases[ currentPhrase ].conditions, onPhraseCheck );
			}
		}
	}
	
	public function checkUserPhrases( phrases : Array, onResult : Function ) : void {
		var availablePhrases : Array = new Array();
		
		var currentPhrase : int = 0;
		var checker : ConditionChecker = new ConditionChecker();
		checker.checkConditions( phrases[ currentPhrase ].conditions, onPhraseCheck );
		
		function onPhraseCheck( result : Boolean ) : void {
			if ( result ) {
				availablePhrases.push( phrases[ currentPhrase ] );
			}
			currentPhrase++;
			
			if ( currentPhrase > phrases.length - 1 ) {
				onResult( availablePhrases );
				return;
			}
			checker.checkConditions( phrases[ currentPhrase ].conditions, onPhraseCheck );
		}
	}
	
	private function display( npcPhrase : Object ) : void {
		
		var option : DialogOption;
		
		for each ( option in _currentOptions ) {
			this.removeChild( option );
		}
		
		_currentOptions.splice( 0 );
		
		npcText = npcPhrase.text;
		var allUserPhrases : Array = getPhraseChildren( npcPhrase.id );
		
		if ( allUserPhrases.length == 0 ) {
			allUserPhrases.push({ id: -1, text: _( "End dialog" ) } );
		}
		
		checkUserPhrases( allUserPhrases, onUserPhrasesCheck );
		
		function onUserPhrasesCheck( userPhrases : Array ) : void {
			
			
			for each ( var phrase : Object in userPhrases ) {
				option = new DialogOption( phrase );
				addChild( option );
				_currentOptions.push( option );
				option.addEventListener(OptionEvent.SELECTED, onOptionSelected );
			}
			
			setTimeout( redrawOptions, 4 );
		
			
			
			// redraw( DIALOG_VIEWER_WIDTH, optionsY + BG_MARGIN_BOT );
			// redrawContentAreaBg(optionsY + BG_MARGIN_BOT);
		}
	}
	
	
	/**
	 *	@inheritDoc
	 */
	protected function redrawOptions () : void {
		
		var optionsY : Number = _npcText_tf.y + _npcText_tf.height + 20;
		
		for each( var option : DialogOption in  this._currentOptions) {
				option.x = CONTENT_AREA_MARGIN + NPC_TEXT_MARGIN;
				option.y = optionsY;
				optionsY += option.getHeight();
		}
		
		this.redraw();
		
	}
	
	/**
	 * On option selected
	 */
	private function onOptionSelected( e : OptionEvent ) : void {
		
		this.openingExplicitNode = false;
		
		var option : DialogOption = DialogOption( e.currentTarget );
		
		if ( option.phrase.functions == undefined ) {
			option.phrase.functions = [];
		}
		var funcExecutor : FunctionExecutor = new FunctionExecutor();
		funcExecutor.executeFunctions( option.phrase.functions, onFunctionsExecuted );
		
		trace( "[dm.game.windows.dialogviewer.DialogViewer.onOptionSelected] this.openingExplicitNode : " + this.openingExplicitNode );
		
		function onFunctionsExecuted( result : Object ) : void {
			var npcPhrases : Array = getPhraseChildren( option.phrase.id );
			
			if ( npcPhrases.length > 0 ) {
				if ( openingExplicitNode ) {
					Alert.show( "You can\'t use openDialogNode function if phrase contains child nodes!", _("Dialog viewer") );
					return;
				}
				checkNpcPhrases( npcPhrases );
			} else {
				trace( "dm.game.windows.dialogviewer.DialogViewer.onOptionSelected() : End of dialog");
				if ( !_initializing && !openingExplicitNode ) {
					destroy();
				}
			}
		}
	}
	
	private function getPhraseChildren( parentPhraseId : int ) : Array {
		var phraseChildren : Array = new Array();
		
		for each ( var phrase : Object in _phrases ) {
			if ( phrase.parent_id == parentPhraseId ) {
				phraseChildren.push( phrase );
			}
		}
		return phraseChildren;
	}

	override public function update( ... params ) : void {
		dialogId = params[ 0 ];
		this.renderDialog();
	}
	
	override public function draw() : void {		
		_npcText_tf = new TextField();
		_npcText_tf.x = CONTENT_AREA_MARGIN + NPC_TEXT_MARGIN;
		_npcText_tf.y = CONTENT_AREA_MARGIN_TOP + NPC_TEXT_MARGIN;
		_npcText_tf.width = DIALOG_VIEWER_WIDTH - ( CONTENT_AREA_MARGIN * 2 + NPC_TEXT_MARGIN * 2 );
		_npcText_tf.multiline = true;
		_npcText_tf.wordWrap = true;
		_npcText_tf.embedFonts = true;
		_npcText_tf.selectable = false;
		addChild( _npcText_tf );
		
		super.draw();	
	}
	
	private function set npcText( text : String ) : void {
		_npcText_tf.text = unescape( text );
		var font : Font = new dmLight();
		_npcText_tf.setTextFormat( DynamicStyleManager.getStyleForClass( DialogOption, "textFormat" ) ); // new TextFormat( font.fontName, 12, 0x333333 ) );
		_npcText_tf.height = _npcText_tf.textHeight + 5;
	}
}

}