<?php

// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Form for editing simulator block instances.
 *
 * @package   block_simulator
 * @copyright 1999 onwards Martin Dougiamas (http://dougiamas.com)
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

class block_simulator extends block_base {

    function init() {
        $this->title = get_string('pluginname', 'block_simulator');
    }

    function applicable_formats() {
        return array('all' => true);
    }

    function get_content() {
        global $USER, $CFG, $SESSION;
		
        if ($this->content !== NULL) {
            return $this->content;
        }
		
		$link = "http://vds000004.hosto.lt/dm?room=patyciu";
		
		if ( isset( $USER->username ) ) {
			
			$key = 'Darnus_miestas_2013';
			
			$string = $USER->username;
			
			$encrypted_auth = urlencode( base64_encode( base64_encode( $string ) ) ); // urlencode( base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5($key), $string, MCRYPT_MODE_CBC, md5(md5($key)))) );
			
			$string = date("Y-m-d");
			$encrypted_date = urlencode( base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5($key), $string, MCRYPT_MODE_CBC, md5(md5($key)))) );
			
			$link .= "&s=".$encrypted_auth."&t=".$encrypted_date;
			
		}
		
		$text = "<a href=\"".$link."\">Simuliatorius</a>";
		
		$this->content = new stdClass;
        $this->content->footer = '';
		
		$this->content->text = $text;
		
        return $this->content;
    }

    /**
     * The block should only be dockable when the title of the block is not empty
     * and when parent allows docking.
     *
     * @return bool
     */
    public function instance_can_be_docked() {
        return (!empty($this->config->title) && parent::instance_can_be_docked());
    }
}
