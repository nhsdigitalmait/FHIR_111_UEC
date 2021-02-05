<?xml version="1.0"?>

<!-- changes the patient name in the cancel appointment scenario -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" version="1.0">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="fhir:Appointment/fhir:contained/fhir:Patient/fhir:name/fhir:family/@value">
		<xsl:attribute name="value"><xsl:value-of select="concat(.,'xxxxx')"/></xsl:attribute>
	</xsl:template>

	<xsl:template match="fhir:Appointment/fhir:status/@value">
		<xsl:attribute name="value">cancelled</xsl:attribute>
	</xsl:template>

	<!-- match all atts all nodes -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
