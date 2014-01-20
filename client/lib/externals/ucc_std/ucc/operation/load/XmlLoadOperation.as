package ucc.operation.load  {
	
/**
 * XML load operation.
 *
 * @version $Id: XmlLoadOperation.as 1 2013-01-03 11:14:03Z rytis.alekna $
 */
public class XmlLoadOperation extends UrlLoadOperation {
	
	/** Xml prop */
	protected var xml	: XML;
	
	/**
	 * Class constructor
	 */
	public function XmlLoadOperation ( url : * ) {
		super( url );
	}
	
	/**
	 * Process data
	 */
	override protected function processData() : void  {
		this.xml = new XML(this.data);
		super.processData();
	}
	
	/**
	 * Return dowloaded xml
	 * @return	dowloaded xml
	 */
	public function getXml () : XML {
		return this.xml;
	}
	
}
	
}