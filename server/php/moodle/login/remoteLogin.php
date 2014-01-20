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
 * Main login page.
 *
 * @package    core
 * @subpackage auth
 * @copyright  1999 onwards Martin Dougiamas  http://dougiamas.com
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require('../config.php');

$context = get_context_instance(CONTEXT_SYSTEM);
$PAGE->set_context($context);

/// auth plugins may override these - SSO anyone?
$frm  = false;
$user = false;



/// Define variables used in page
$site = get_site();

if ($user) {
	$frm->username = $user->username;
} else {
	$frm = data_submitted();
}

/// Check if the user has actually submitted login data to us


if ($frm && isset($frm->username)) {                             // Login WITH cookies

    $user = authenticate_user_login($frm->username, $frm->password);
	
	// echo var_dump($user);
	
    if ($user) {
        echo "true";
    } else {
		echo "false";
    }
} else {
	echo "false";
}

