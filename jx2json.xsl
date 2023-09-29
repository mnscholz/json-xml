<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:jx="https://github.com/mnscholz/json-xml/"
        >
        <xsl:output method="text" encoding="UTF-8" />
        <xsl:template match="/">
                <xsl:apply-templates select="jx:null|jx:true|jx:false|jx:number|jx:string|jx:array|jx:object"/>
        </xsl:template>
        <xsl:template match="jx:null">null</xsl:template>
        <xsl:template match="jx:true">true</xsl:template>
        <xsl:template match="jx:false">false</xsl:template>
        <xsl:template match="jx:number"><xsl:value-of select="."/></xsl:template>
        <xsl:template match="jx:string">
                <xsl:text>"</xsl:text>
                <xsl:call-template name="jx:escape-string">
                        <xsl:with-param name="str" select="."/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
        </xsl:template>
        <xsl:template match="jx:array">
                <xsl:text>[</xsl:text>
                <xsl:for-each select="jx:null|jx:true|jx:false|jx:number|jx:string|jx:array|jx:object">
                        <xsl:if test="position() > 1">,</xsl:if>
                        <xsl:apply-templates select="."/>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
        </xsl:template>
        <xsl:template match="jx:object">
                <xsl:text>{</xsl:text>
                <xsl:for-each select="jx:key">
                        <xsl:if test="position() > 1">,</xsl:if>
                        <xsl:text>"</xsl:text>
                <xsl:call-template name="jx:escape-string">
                        <xsl:with-param name="str" select="@name"/>
                </xsl:call-template>
                <xsl:text>":</xsl:text>
                        <xsl:apply-templates select="jx:null|jx:true|jx:false|jx:number|jx:string|jx:array|jx:object"/>
                </xsl:for-each>
                <xsl:text>}</xsl:text>
        </xsl:template>
        <xsl:template name="jx:escape-string">
                <xsl:param name="str"/>
                <!-- Only escape quots ("), all other chars should be fine -->
                <xsl:choose>
                        <xsl:when test="contains($str, '&quot;')">
                                <xsl:value-of select="substring-before($str, '&quot;')"/>
                                <xsl:text>\"</xsl:text>
                                <xsl:call-template name="jx:escape-string">
                                        <xsl:with-param name="str" select="substring-after($str, '&quot;')"/>
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="$str"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
</xsl:stylesheet>
