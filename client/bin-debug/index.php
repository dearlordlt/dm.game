<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>Žaidimas „Darnus miestas“</title>
	<meta name="description" content="" />
	
	<script type="text/javascript" src="js/swfobject.js"></script>
	<script type="text/javascript" src="currentversiontimestamp.js"></script>
	<script>
		var flashvars = {
			room: "<?php 
				if ( isset( $_GET['room'] )) {
					echo $_GET['room']; 
				} else {
					echo "mokyklos-foje";
				}
			?>",
			<?php 
				if ( isset($_GET['builderMode'] ) && $_GET['builderMode'] == "true" ) {
					echo "builderMode : \"true\""; 
				} else {
					echo "builderMode : \"false\""; 
				}
				
			?>,
			<?php 
				if ( isset($_GET['explicitRoom'] ) && $_GET['explicitRoom'] == "true" ) {
					echo "explicitRoom : \"true\""; 
				} else {
					echo "explicitRoom : \"false\""; 
				}
				
			?>,
			<?php 
				if ( isset($_GET['statsEnabled'] ) && $_GET['statsEnabled'] == "true" ) {
					echo "statsEnabled : \"true\""; 
				} else {
					echo "statsEnabled : \"false\""; 
				}
				
			?>,
			serviceGatewayUrl: "http://vds000004.hosto.lt/new_amfphp/Amfphp/",
			esGatewayUrl: "213.190.49.139:9899"
			<?php 
				if ( isset($_GET['s']) && isset($_GET['t']) ) {
					
					$key = 'Darnus_miestas_2013';
					$encrypted = $_GET['s'];
					
					$decrypted_auth =  base64_decode( base64_decode( urldecode( $encrypted ) ) ); // rtrim(mcrypt_decrypt(MCRYPT_RIJNDAEL_256, md5($key), base64_decode(urldecode($encrypted)), MCRYPT_MODE_CBC, md5(md5($key))), "\0");
					
					// $encrypted = $_GET['t'];
					// $decrypted_date = rtrim(mcrypt_decrypt(MCRYPT_RIJNDAEL_256, md5($key), base64_decode(urldecode($encrypted)), MCRYPT_MODE_CBC, md5(md5($key))), "\0");
					
					echo ",auth:\"".$decrypted_auth."\"";
					
					echo ",p:\"".$encrypted."\"";
					
				}
			?>,
			<?php 
				if ( isset($_GET['skin'] ) ) {
					echo "skin : \"".$_GET['skin']."\""; 
				} else {
					echo "skin : \"orange\""; 
				}
				
			?>			
		};
		var params = {
			menu: "false",
			scale: "noScale",
			allowFullscreen: "true",
			allowScriptAccess: "always",
			bgcolor: "",
			wmode: "direct" // can cause issues with FP settings & webcam
		};
		var attributes = {
			id:"dmWorldBuilder"
		};
		swfobject.embedSWF(
			"Main.swf?version=" + currentVersionTimeStamp, 
			"altContent", "100%", "100%", "11.5.0", 
			"expressInstall.swf", 
			flashvars, params, attributes);
	</script>
	<style>
		html, body { height:100%; overflow:hidden; }
		body { margin:0; }
	</style>
</head>
<body>
	<div id="altContent">
		<h1>Darnus miestas</h1>
		<p><a href="http://www.adobe.com/go/getflashplayer">Get Adobe Flash player</a></p>
	</div>
	
<script>
	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

	ga('create', 'UA-40924278-1', 'hosto.lt');
	ga('send', 'pageview');
</script>
	
</body>
</html>