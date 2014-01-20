package dm.game.windows.gallery {
	import dm.game.data.service.GalleryService;
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import fl.containers.UILoader;
	import fl.controls.Button;
	import fl.controls.ProgressBar;
	import flash.display.DisplayObjectContainer;
	import fl.controls.Label;
	import flash.events.Event;
	

/**
 * 
 * @version $Id: GalleryImageViewer.as 215 2013-09-29 14:28:49Z rytis.alekna $
 */
public class GalleryImageViewer extends DmWindow {
	
	/** Image UI loader */
	public var imageUILoaderDO				: UILoader;	

	/** Label */
	public var labelDO						: Label;

	/** Description label */
	public var descriptionLabelDO			: Label;	
	
	/** Vote up button */
	public var voteUpButtonDO				: Button;

	/** Vote down button */
	public var voteDownButtonDO				: Button;

	/** Rating progress bar */
	public var ratingProgressBarDO			: ProgressBar;

	/** Positive rating label */
	public var positiveRatingLabelDO		: Label;

	/** Negative rating label */
	public var negativeRatingLabelDO		: Label;	
	
	/** imageData */
	protected var imageData 				: Object;
	
	/**
	 * (Constructor)
	 * - Returns a new GalleryImageViewer instance
	 */
	public function GalleryImageViewer(parent:DisplayObjectContainer=null, imageData : Object = null ) {
		this.imageData = imageData;
		super(parent, this.imageData.label );
	}
	
	/**
	 *	@inheritDoc
	 */
	public override function initialize () : void {
		this.imageUILoaderDO.source = this.imageData.source;
		
		GalleryService.getImageRating( this.imageData.id, MyManager.instance.avatarId )
			.addResponders( this.onRatingLoaded )
			.call();		
		
		this.voteUpButtonDO.addEventListener(Event.CHANGE, this.onVoteButtonClick );
		this.voteDownButtonDO.addEventListener( Event.CHANGE, this.onVoteButtonClick );					
		
	}
	
	/**
	 *	On vote up button click
	 */
	protected function onVoteButtonClick ( event : Event ) : void {
		
		if ( Button( event.target ).selected ) {
			var vote : String = ( event.target == this.voteUpButtonDO ) ? "Y" : "N";
			GalleryService.rateImage( MyManager.instance.avatar.id, this.imageData.id, vote )
				.addResponders( this.onRatingLoaded )
				.call();
		} else {
			GalleryService.removeRating( MyManager.instance.avatar.id, this.imageData.id )
				.addResponders( this.onRatingLoaded )
				.call();
		}
		
	}	
	
	/**
	 *	On rating loaded
	 */
	protected function onRatingLoaded ( response : Object ) : void {
		
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
	 *	@inheritDoc
	 */
	public override function postInitialize (  ) : void {
		this.labelDO.text = this.imageData.label;
		this.descriptionLabelDO.text = this.imageData.description;
	}
	
}

}