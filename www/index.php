
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="<?php echo $themeroot; ?>/images/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>

<!-- end of project description -->

<BR>
<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>

<BR>
<p><B>presentations on available functionality</B></p>

<p>Oehlschl&auml;gel, Adler (2009) <A HREF="ff&bit_UseR!2009.pdf"><I>Managing data.frames with package 'ff' and fast filtering with package 'bit'</I></A>. Presentation at UseR!2009, Agrocampus, Rennes</p>

<p>Adler, Oehlschl&auml;gel, Nenadic, Zucchini (2008) <A HREF="ff2.0_UseR!2008.pdf"><I>Large atomic data in R package 'ff'</I></A>. Presentation at UseR!2008, statistics department, University of Dortmund</p>

<p>Adler, Oehlschl&auml;gel, Nenadic, Zucchini (2008) <A HREF="ff2.0_jsm2008.pdf"><I>High-Performance Processing of Large Data Sets via Memory Mapping: A Case Study in R And C++</I></A>. Presentation at Joint Statistical Meetings, Denver, Colorado.</p>

<BR>
<p><B>presentations on future functionality</B></p>

<p>Oehlschl&auml;gel, Adler, Nenadic, Zucchini (2008) <A HREF="R.ff0.1_UseR!2008.pdf"><I>A first glimpse into 'R.ff'</I></A>. Presentation at UseR!2008, statistics department, University of Dortmund</p>


</body>
</html>
