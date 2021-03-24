<?xml version="1.0"?>

<!-- remove appt id and telecom for initial booking also changes contact rank to 1-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" version="1.0">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="fhir:Appointment/fhir:id"/>
	<xsl:template match="fhir:Patient/fhir:telecom"/>

	<xsl:template match="fhir:Appointment/fhir:created/@value">
		<xsl:attribute name="value"><xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"/></xsl:attribute>
	</xsl:template>

	<!-- change contact telecom rank to 1-->
	<xsl:template match="fhir:Appointment/fhir:contained/fhir:Patient/fhir:contact/fhir:telecom/fhir:rank/@value">
		<xsl:attribute name="value"><xsl:value-of select="'1'"/></xsl:attribute>
	</xsl:template>

	<!-- match all atts all nodes -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
