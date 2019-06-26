<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<!-- =====================================================================
 | Project:                Common
 | Title:                     Common XSL templates.
 | Filename:            common.xsl
 | Created:              07-01-2002
 | Authors:              isaac perkins <isaac.perkins.1@gmail.com>
 | Description:       bunch of common templates offering general use functionality
  ========================================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="exsl" version="1.1">
  <xsl:output encoding="ASCII"/>
  <!--Variables for case conversion -->
  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <!--

    Creates css style elements from comma seperated list of 'paths/file/names.css'

  -->
  <xsl:template name="style">
    <xsl:param name="css" select="."/>
    <xsl:variable name="separator" select="','"/>
    <xsl:choose>
      <xsl:when test="not(contains($css, $separator))">
        <link rel="stylesheet" href="{normalize-space($css)}" type="text/css"/>
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" href="{normalize-space(substring-before($css, $separator))}" type="text/css"/>
        <xsl:call-template name="style">
          <xsl:with-param name="css" select="substring-after($css, $separator)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--

    Creates js script tags

-->
  <xsl:template name="script">
    <xsl:param name="js" select="."/>
    <xsl:variable name="separator" select="','"/>
    <xsl:choose>
      <xsl:when test="not(contains($js, $separator))">
        <script src="{normalize-space($js)}" type="text/javascript"/>
      </xsl:when>
      <xsl:otherwise>
        <script src="{normalize-space(substring-before($js, $separator))}" type="text/javascript"/>
        <xsl:call-template name="script">
          <xsl:with-param name="js" select="substring-after($js, $separator)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--

      include (actually require) a php file

  <xsl:call-template name="include_php">
    <xsl:with-param name="file_name" select="path'"/>
  </xsl:call-template>

  -->
  <xsl:template name="include_php">
    <xsl:param name="file_name"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[<?php require_once ']]></xsl:text>
    <xsl:value-of select="$file_name"/>
    <xsl:text disable-output-escaping="yes"><![CDATA['; ?>]]></xsl:text>
  </xsl:template>



  <!--
    id from title

		Convert a title to a string useful as an id..

		ie: To Lower Case And Space As Underscore = to_lower_case_and_space_as_underscore

		EG: V8 Supercars = v8_supercars

		Usage:
		<xsl:call-template name="id_from_title">
			<xsl:with-param name="string_to_convert"><xsl:value-of select="XPATH/TO/NODE/TO/CONVERT"/></xsl:with-param>
		</xsl:call-template>
	-->
  <xsl:template name="id_from_title">
    <xsl:param name="string_to_convert"/>
    <xsl:param name="delimiter" select="'_'"/>
    <xsl:if test="string-length($string_to_convert) &gt; 0">
      <xsl:call-template name="str_convertcase">
        <xsl:with-param name="toconvert">
          <xsl:call-template name="str_replace">
            <xsl:with-param name="stringToSearch" select="$string_to_convert"/>
            <xsl:with-param name="stringToFind" select="' '"/>
            <xsl:with-param name="stringToReplaceWith">
              <xsl:value-of select="$delimiter"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="conversion" select="'lower'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!--
		Convert an id to a string useful as a title
		ie: Replace _ with a space -> to_lower_case_and_space_as_underscore = To lower case and space as underscore

		Usage:
		<xsl:call-template name="title_from_id">
			<xsl:with-param name="string_to_convert"><xsl:value-of select="XPATH/TO/NODE/TO/CONVERT"/></xsl:with-param>
			<xsl:with-param name="delimiter">_</xsl:with-param>
		</xsl:call-template>
	-->
  <xsl:template name="title_from_id">
    <xsl:param name="string_to_convert"/>
    <xsl:param name="delimiter" select="'_'"/>
    <xsl:if test="string-length($string_to_convert) &gt; 0">
      <xsl:call-template name="str_convertcase">
        <xsl:with-param name="toconvert">
          <xsl:call-template name="str_replace">
            <xsl:with-param name="stringToSearch" select="$string_to_convert"/>
            <xsl:with-param name="stringToFind" select="$delimiter"/>
            <xsl:with-param name="stringToReplaceWith">&nbsp;</xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="conversion" select="'proper'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <!--

      Case conversion

    	<xsl:call-template name="str_convertcase">
    		<xsl:with-param name="toconvert" select="path/to/node/to/convert"/>
    		<xsl:with-param name="conversion" select="'lower'"/>
    	</xsl:call-template>

    	convert uppercase:
    	<xsl:with-param name="conversion" select="'upper'"/>
    
      1st char uppercase
      <xsl:with-param name="conversion" select="'capitalize'"/>
    -->
  <xsl:template name="str_convertcase">
    <xsl:param name="toconvert"/>
    <xsl:param name="conversion"/>
    <xsl:choose>
      <xsl:when test="$conversion='lower'">
        <xsl:value-of select="translate($toconvert,$ucletters,$lcletters)"/>
      </xsl:when>
      <xsl:when test="$conversion='upper'">
        <xsl:value-of select="translate($toconvert,$lcletters,$ucletters)"/>
      </xsl:when>
       <xsl:when test="$conversion='capitalize'">
        <xsl:value-of select="translate(substring($toconvert,1,1),$lcletters,$ucletters)"/><xsl:value-of select="substring($toconvert,2,string-length($toconvert)-1)"/>
      </xsl:when>
      <xsl:when test="$conversion='proper'">
        <xsl:call-template name="convertpropercase">
          <xsl:with-param name="toconvert">
            <xsl:value-of select="translate($toconvert,$ucletters,$lcletters)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$toconvert"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Called from str_convertcase, don't call directly -->
  <xsl:template name="convertpropercase">
    <xsl:param name="toconvert"/>
    <xsl:if test="string-length($toconvert) &gt; 0">
      <xsl:variable name="f" select="substring($toconvert, 1, 1)"/>
      <xsl:variable name="s" select="substring($toconvert, 2)"/>
      <xsl:call-template name="str_convertcase">
        <xsl:with-param name="toconvert" select="$f"/>
        <xsl:with-param name="conversion">upper</xsl:with-param>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="contains($s,' ')"><xsl:value-of select="substring-before($s,' ')"/>
					<xsl:call-template name="convertpropercase"><xsl:with-param name="toconvert" select="substring-after($s,' ')"/></xsl:call-template>
				</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$s"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <!--
	Replace one string with another.


	<xsl:call-template name="str_replace">
		<xsl:with-param name="stringToSearch">search this</xsl:with-param>
		<xsl:with-param name="stringToFind"> </xsl:with-param>
		<xsl:with-param name="stringToReplaceWith">_</xsl:with-param>
	</xsl:call-template>

	-->
  <xsl:template name="str_replace">
    <xsl:param name="stringToSearch"/>
    <xsl:param name="stringToFind"/>
    <xsl:param name="stringToReplaceWith"/>
    <xsl:choose>
      <xsl:when test="string-length($stringToSearch) = 0 or string-length($stringToFind) = 0">
        <b style="color:red">All param's require a value</b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($stringToSearch,$stringToFind)">
            <xsl:value-of select="concat(substring-before($stringToSearch,$stringToFind),$stringToReplaceWith)"/>
            <xsl:call-template name="str_replace">
              <xsl:with-param name="stringToSearch" select="substring-after($stringToSearch,$stringToFind)"/>
              <xsl:with-param name="stringToFind" select="$stringToFind"/>
              <xsl:with-param name="stringToReplaceWith" select="$stringToReplaceWith"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stringToSearch"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--

  String Padding -
  str_pad ::
		str_pad (string, count, with, direction)

		eg. str_pad ('1', 3, '0', 'left')  = 001
		  str_pad ('1', 3, '0', 'right') = 100

		blank template:
		<xsl:call-template name="str_pad">
		  <xsl:with-param name="string"></xsl:with-param>
		  <xsl:with-param name="count"></xsl:with-param>
		  <xsl:with-param name="with"></xsl:with-param>
		  <xsl:with-param name="direction"></xsl:with-param>
		</xsl:call-template>
	-->
  <xsl:template name="str_pad">
    <xsl:param name="string"/>
    <xsl:param name="count"/>
    <xsl:param name="with"/>
    <xsl:param name="direction">left</xsl:param>
    <xsl:param name="currlength" select="string-length($string)"/>
    <xsl:if test="$direction!='left' and $currlength=string-length($string)">
      <xsl:value-of select="$string"/>
    </xsl:if>
    <xsl:if test="$currlength &lt; $count">
      <xsl:value-of select="$with"/>
      <xsl:call-template name="str_pad">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="count" select="$count"/>
        <xsl:with-param name="with" select="$with"/>
        <xsl:with-param name="direction" select="$direction"/>
        <xsl:with-param name="currlength" select="$currlength + 1"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="$currlength=$count and $direction='left'">
      <xsl:value-of select="$string"/>
    </xsl:if>
  </xsl:template>


  <!--

    String substitution

		str_subst (text, replace, with)  - string substitution

		eg. str_subst('cat','at','hat') = 'chat'

		blank template:
		<xsl:call-template name="str_subst">
		  <xsl:with-param name="text"></xsl:with-param>
		  <xsl:with-param name="replace"></xsl:with-param>
		  <xsl:with-param name="with"></xsl:with-param>
		</xsl:call-template>

	-->
  <xsl:template name="str_subst">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="string-length($replace) = 0">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:variable name="before" select="substring-before($text, $replace)"/>
        <xsl:variable name="after" select="substring-after($text, $replace)"/>
        <xsl:value-of select="$before"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="str_subst">
          <xsl:with-param name="text" select="$after"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




  <!--

      Format Date

	     prints date according to given format

	     param $date    - date input, eg. "2016-11-21T12:27:09.056179+11:00" aka timestamp
	     param $format  - (DD/MM/YYYY) or (DD/MM/YYYY HH:NN ) or (MM/DD/YYYY) or (MM-DD-YYYY HH:NN)
	     
	     EG:
	     
      <xsl:call-template name="date_formatted">
        <xsl:with-param name="date" select="path/to/node"/>
        <xsl:with-param name="format" select="'MM/DD/YYYY HH:NN'"/>
      </xsl:call-template>
	     
	-->
  <xsl:template name="date_formatted">
    <xsl:param name="date"/>
    <xsl:param name="format"/>
    <xsl:variable name="DD">
      <xsl:choose>
        <xsl:when test="contains($date,'-')">
          <xsl:value-of select="substring($date,9,2)"/>
        </xsl:when>
        <xsl:when test="contains($date,'/')">
          <xsl:call-template name="str_pad">
            <xsl:with-param name="string" select="substring-before(substring-after($date,'/'),'/')"/>
            <xsl:with-param name="count">2</xsl:with-param>
            <xsl:with-param name="with">0</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="d" select="number($DD)"/>
    <xsl:variable name="MM">
      <xsl:choose>
        <xsl:when test="contains($date,'-')">
          <xsl:value-of select="substring($date,6,2)"/>
        </xsl:when>
        <xsl:when test="contains($date,'/')">
          <xsl:call-template name="str_pad">
            <xsl:with-param name="string" select="substring-before($date,'/')"/>
            <xsl:with-param name="count">2</xsl:with-param>
            <xsl:with-param name="with">0</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="YYYY">
      <xsl:choose>
        <xsl:when test="contains($date,'-')">
          <xsl:value-of select="substring($date,1,4)"/>
        </xsl:when>
        <xsl:when test="contains($date,'/')">
          <xsl:value-of select="substring-after(substring-after(substring-before($date,' '),'/'),'/')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="hh">
      <xsl:choose>
        <xsl:when test="contains($date,'-')">
          <xsl:value-of select="number(substring-before(substring-after($date,'T'),':'))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="h">
      <xsl:choose>
        <xsl:when test="$hh &gt; 12">
          <xsl:value-of select="$hh mod 12"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$hh"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- mins -->
    <xsl:variable name="nn">
      <xsl:choose>
        <xsl:when test="contains($date,'-')">
          <xsl:value-of select="substring-after(substring-after($date,'T'),':')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="Month">
      <xsl:call-template name="date_mm_to_month">
        <xsl:with-param name="MM" select="$MM"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="pm">
      <xsl:choose>
        <xsl:when test="$hh &gt; 12">pm</xsl:when>
        <xsl:otherwise>am</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$date!=''">
      <xsl:choose>
        <xsl:when test="$format='DD/MM/YYYY'">
          <xsl:value-of select="concat($DD,'/',$MM,'/',$YYYY)"/>
        </xsl:when>
          <xsl:when test="$format='MM/DD/YYYY'">
          <xsl:value-of select="concat($MM,'/',$DD,'/',$YYYY)"/>
        </xsl:when>
           <xsl:when test="$format='MM-DD-YYYY'">
          <xsl:value-of select="concat($MM,'-',$DD,'-',$YYYY)"/>
        </xsl:when>
        <xsl:when test="$format='MM-DD-YYYY HH:NN'">
          <xsl:value-of select="concat($MM,'-',$DD,'-',$YYYY, $h,':',$nn)"/>
        </xsl:when>
         <xsl:when test="$format='MM/DD/YYYY'">
          <xsl:value-of select="concat($MM,'/',$DD,'/',$YYYY)"/>
        </xsl:when>
        <xsl:when test="$format='YYYY-MM-DD'">
          <xsl:value-of select="concat($YYYY,'-',$MM,'-',$DD)"/>
        </xsl:when>
        <xsl:when test="$format='d Month YYYY'">
          <xsl:value-of select="concat($d,' ',$Month,' ',$YYYY)"/>
        </xsl:when>
        <xsl:when test="$format='Month YYYY'">
          <xsl:value-of select="concat($Month,' ',$YYYY)"/>
        </xsl:when>
        <xsl:when test="$format='d Month'">
          <xsl:value-of select="concat($d,' ',$Month)"/>
        </xsl:when>
        <xsl:when test="$format='h:nn pm'">
          <xsl:value-of select="concat($h,':',$nn,' ',$pm)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <!-- date_mm_to_month ::
	     prints month name from month number
	     param $MM   - date input, eg. "2004-09-17T17:53"
	-->
  <xsl:template name="date_mm_to_month">
    <xsl:param name="MM"/>
    <xsl:choose>
      <xsl:when test="$MM='01'">January</xsl:when>
      <xsl:when test="$MM='02'">February</xsl:when>
      <xsl:when test="$MM='03'">March</xsl:when>
      <xsl:when test="$MM='04'">April</xsl:when>
      <xsl:when test="$MM='05'">May</xsl:when>
      <xsl:when test="$MM='06'">June</xsl:when>
      <xsl:when test="$MM='07'">July</xsl:when>
      <xsl:when test="$MM='08'">August</xsl:when>
      <xsl:when test="$MM='09'">September</xsl:when>
      <xsl:when test="$MM='1'">January</xsl:when>
      <xsl:when test="$MM='2'">February</xsl:when>
      <xsl:when test="$MM='3'">March</xsl:when>
      <xsl:when test="$MM='4'">April</xsl:when>
      <xsl:when test="$MM='5'">May</xsl:when>
      <xsl:when test="$MM='6'">June</xsl:when>
      <xsl:when test="$MM='7'">July</xsl:when>
      <xsl:when test="$MM='8'">August</xsl:when>
      <xsl:when test="$MM='9'">September</xsl:when>
      <xsl:when test="$MM='10'">October</xsl:when>
      <xsl:when test="$MM='11'">November</xsl:when>
      <xsl:when test="$MM='12'">December</xsl:when>
    </xsl:choose>
  </xsl:template>



  <!-- Comments Document ::
		 Comments - Document details (generated by/ generated date)
	    <xsl:call-template name="comments_document">
	    	<xsl:with-param name="document_name" select='YouDocumentName'/>
	    	<xsl:with-param name="document_publish_date" select="'01-01-2009'"/>
	    </xsl:call-template>
	-->
  <xsl:template name="comments_document">
    <xsl:param name="document_name"/>
    <xsl:param name="document_publish_date"/>
    <xsl:call-template name="format_newLine"/>
    <xsl:comment>
			generated by: <xsl:value-of select="$document_name"/>
			<xsl:call-template name="format_newLine"/>
			created: <xsl:value-of select="$document_publish_date"/>
		</xsl:comment>
    <xsl:call-template name="format_newLine"/>
  </xsl:template>
  <!-- Comments - Mark the start/end (in output) of an xsl document -->
  <xsl:template name="comments_break">
    <xsl:param name="title"/>
    <xsl:param name="comments"/>
    <xsl:call-template name="format_newLine"/>
    <xsl:comment>=========<xsl:value-of select="$comments"/>===<xsl:value-of select="$title"/>=========</xsl:comment>
  </xsl:template>



  <!--

    Code ouput formatting

		Format output code
  -->
  <!-- Write a new line to output html-->
  <xsl:template name="format_newLine">
    <xsl:text>
    </xsl:text>
  </xsl:template>
  <!-- Write a new to output html-->
  <xsl:template name="format_newLines">
    <xsl:param name="n" select="1"/>
    <xsl:if test="$n &gt; 0">
      <xsl:text>	</xsl:text>
      <xsl:call-template name="format_newLines">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- Write a tab to output html-->
  <xsl:template name="format_tab">
    <xsl:text>	</xsl:text>
  </xsl:template>
  <!-- Write a tab to output html-->
  <xsl:template name="format_tabs">
    <xsl:param name="n" select="1"/>
    <xsl:if test="$n &gt; 0">
      <xsl:text>	</xsl:text>
      <xsl:call-template name="format_tabs">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- Write space in output html-->
  <xsl:template name="format_space">
    <xsl:text>   </xsl:text>
  </xsl:template>
  <!-- Write n * space's in output html

	example, call this template (put's the resulting value into variable $indent):
	<xsl:variable name="indent">
   		<xsl:call-template name="format_spaces">
   			<xsl:with-param name="n" select="5">
   		</xsl:call-template>
   	</xsl:variable>

   	<xsl:value-of select="$indent"/>
	-->
  <xsl:template name="format_spaces">
    <xsl:param name="n" select="1"/>
    <xsl:if test="$n &gt; 0">
      <xsl:text>   </xsl:text>
      <xsl:call-template name="format_spaces">
        <xsl:with-param name="n" select="$n - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
