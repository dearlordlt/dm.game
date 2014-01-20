<?php

/**
 *  This file is part of amfPHP
 *
 * LICENSE
 *
 * This source file is subject to the license that is bundled
 * with this package in the file license.txt.
 * @package Amfphp_Backoffice_Generators
 */

/**
 * generates a Flash project for UCC services
 *
 * @author Ariel Sommeria-klein
 * @package Amfphp_Backoffice_Generators
 */
class AmfphpUccClientGenerator extends Amfphp_BackOffice_ClientGenerator_LocalClientGenerator {

    /**
     * constructor
     */
    public function __construct() {
        parent::__construct(array('as'), dirname(__FILE__) . '/Template');
    }

    /**
     * get ui call text
     * @return string
     */
    public function getUiCallText() {
        return "UCC Flash Project";
    }

    /**
     * info url
     * @return string
     */
    public function getInfoUrl() {
        return "http://www.silexlabs.org/amfphp/documentation/client-generators/flash-creative-suite/";
    }
	
    /**
     * generate project based on template
     * @param array $services . note: here '/' in each service name is replaced by '__', to avoid dealing with packages
     * @param string $amfphpEntryPointUrl 
     * @param String absolute url to folder where to put the generated code
     * @return null
     */
    public function generate($services, $amfphpEntryPointUrl, $targetFolder) {
        foreach ($services as $service) {
            $service->name = str_replace('/', '__', $service->name);
        }
        $this->services = $services;
        $this->amfphpEntryPointUrl = $amfphpEntryPointUrl;
        Amfphp_BackOffice_ClientGenerator_Util::recurseCopy($this->templateFolderUrl, $targetFolder);
        $it = new RecursiveDirectoryIterator($targetFolder);
        foreach (new RecursiveIteratorIterator($it) as $file) {
            if (In_Array(SubStr($file, StrrPos($file, '.') + 1), $this->codeFileExtensions) == true) {
                $this->fileBeingProcessed = $file;
                $this->processSourceFile($file);
            }
        }
    }	
	
}

?>
