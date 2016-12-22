<?xml version="1.0" encoding="UTF-8"?>
<!-- Upload_TradeCapturedReport.xsl is used to retrive fields from the incoming XML data, so that it can be used as input to a Prepared SQL Statement, that can be used to insert a record into the TRADECAPTUREDREPORT database table.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:dp="http://www.datapower.com/extensions" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:date="http://exslt.org/dates-and-times" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" extension-element-prefixes="dp date regexp" exclude-result-prefixes="dp  date soap" xmlns:xsd="http://sml.com.vn/xsd" xmlns:dpconfig="http://www.datapower.com/param/config">
	<xsl:param name="dpconfig:SignWS"/>
	<xsl:param name="dpconfig:NapasWS"/>
	<xsl:template match="/">
		<!--SIMUALATOR-->		
		<!--UAT
		<xsl:variable name="wsURL">http://sml.com.vn:8081/VAS/services/VASHttpSoap11Endpoint</xsl:variable>
		-->
		<!--Query-->
		<xsl:variable name="wsURL"><xsl:value-of select="$dpconfig:NapasWS"/></xsl:variable>
		<xsl:variable name="wsURL4Sign"><xsl:value-of select="$dpconfig:SignWS"/></xsl:variable>
		
		
		<xsl:variable name="MTI">0200</xsl:variable>
		<xsl:variable name="PrimaryAccountNumber" select="//PrimaryAccountNumber" />		
		<xsl:variable name="ProcessingCode">060000</xsl:variable>
		<!--Them 2 so 00 cuoi transaction amount-->
		<xsl:variable name="TransactionAmount" select="//TransactionAmount" />
		<!-- Them 2 so 0 cuoi cho dung format Napas quy dinh -->
		<xsl:variable name="TransactionAmount">
			<xsl:value-of select="$TransactionAmount"/>00
		</xsl:variable>
		<xsl:variable name="TransmissionDateTime" select="//TransmissionDateTime" />
		<xsl:variable name="AuditNumber" select="//AuditNumber" />
		<xsl:variable name="MerchantType" select="//MerchantType" />
		

		<!--Ma so dai ly Napas cap cho Bank-->		
		<xsl:variable name="AcquiringCode">157979</xsl:variable>
		<xsl:variable name="TermId" select="//TermId" />
		<xsl:variable name="CardAcceptorName" select="//CardAcceptorName" />
		<xsl:variable name="ServiceCode" select="//ServiceCode" />
		<xsl:variable name="BillId" select="//BillId" />
		<xsl:variable name="AdditionalInformation" select="//AdditionalInformation" />
		
		<!--
		<xsl:variable name="SignRequest">
			<xsl:text><xsl:value-of select="$PrimaryAccountNumber" /><xsl:value-of select="$ProcessingCode" /><xsl:value-of select="$TransactionAmount" /><xsl:value-of select="$TransmissionDateTime" /><xsl:value-of select="$AuditNumber" /><xsl:value-of select="$MerchantType" /><xsl:value-of select="$AcquiringCode" /><xsl:value-of select="$TermId" /><xsl:value-of select="$ServiceCode" /><xsl:value-of select="$BillId" /></xsl:text>
		</xsl:variable>
		
		<xsl:variable name="hashValueBase64">		
			<xsl:text><xsl:value-of select ="dp:hash('http://www.w3.org/2000/09/xmldsig#sha1', $SignRequest)" /></xsl:text>
		</xsl:variable>
		
		<xsl:variable name="Signature">
			<xsl:value-of select="dp:sign('http://www.w3.org/2000/09/xmldsig#rsa-sha1', $hashValueBase64, 'name:scb')" />
		</xsl:variable>		
		-->
		
		<xsl:variable name="input"><xsl:value-of select="$MTI" />|<xsl:value-of select="$PrimaryAccountNumber" />|<xsl:value-of select="$ProcessingCode" />|<xsl:value-of select="$TransactionAmount" />|<xsl:value-of select="$TransmissionDateTime" />|<xsl:value-of select="$AuditNumber" />|<xsl:value-of select="$MerchantType" />|<xsl:value-of select="$AcquiringCode" />|<xsl:value-of select="$TermId" />|<xsl:value-of select="$CardAcceptorName" />|<xsl:value-of select="$ServiceCode" />|<xsl:value-of select="$BillId" />|<xsl:value-of select="$AdditionalInformation" /></xsl:variable>
		
		<xsl:variable name="input4Sign"><xsl:value-of select="$MTI" />|<xsl:value-of select="$PrimaryAccountNumber" />|<xsl:value-of select="$ProcessingCode" />|<xsl:value-of select="$TransactionAmount" />|<xsl:value-of select="$TransmissionDateTime" />|<xsl:value-of select="$AuditNumber" />|<xsl:value-of select="$MerchantType" />|<xsl:value-of select="$AcquiringCode" />|<xsl:value-of select="$TermId" />|<xsl:value-of select="$ServiceCode" />|<xsl:value-of select="$BillId" /></xsl:variable>
		
		<!--Goi ham ky du lieu-->
		<xsl:variable name="request4Sign">
		<!--
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://sml.com.vn/xsd">
			   <soapenv:Header/>
			   <soapenv:Body>
				  <xsd:sign>
					 <xsd:data><xsl:value-of select="translate($input4Sign,'|','')"/></xsd:data>
				  </xsd:sign>
			   </soapenv:Body>
			</soapenv:Envelope>
		-->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:smar="http://bian.scb.com.vn/SmartlinkSignatureGenerator/">
		   <soapenv:Header/>
		   <soapenv:Body>
			  <smar:sign>
				 <data><xsl:value-of select="translate($input4Sign,'|','')"/></data>
			  </smar:sign>
		   </soapenv:Body>
		</soapenv:Envelope>
		</xsl:variable>
	
		
		<xsl:variable name="httpHeaders4Sign">
			<header name="SOAPAction">http://bian.scb.com.vn/SmartlinkSignatureGenerator/genSignature</header>
			<header name="Content-Type">text/xml;charset=UTF-8</header>
		</xsl:variable>
		
		<xsl:variable name="soapaction4Sign">http://bian.scb.com.vn/SmartlinkSignatureGenerator/genSignature</xsl:variable>
		
		<xsl:variable name="response4Sign" select="dp:soap-call($wsURL4Sign,
								   $request4Sign/*,
								   null,
								   0,
								   $soapaction4Sign,
								   $httpHeaders4Sign/*,
								   true(),
								   120
								  )"/>
		

		<xsl:variable name="Signature">
			<xsl:value-of select="$response4Sign" />
		</xsl:variable>
		
		<xsl:variable name="request">
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://sml.com.vn/xsd">
			   <soapenv:Header/>
			   <soapenv:Body>
				  <xsd:execute>
					 <xsd:input><xsl:value-of select="$input" />|<xsl:value-of select="$Signature" /></xsd:input>
				  </xsd:execute>
			   </soapenv:Body>
			</soapenv:Envelope>
		</xsl:variable>	

		<xsl:variable name="httpHeaders">
			<header name="SOAPAction">urn:execute</header>
			<header name="Content-Type">text/xml;charset=UTF-8</header>
		</xsl:variable>
		
		<xsl:variable name="soapaction"><xsl:value-of select="dp:request-header('SOAPAction')" /></xsl:variable> 
		
		<!--Ket qua soapaction se la http://vnpayment.vn/Query hoac http://vnpayment.vn/Confirm -->
		<!--Bo dau "" o soapaction-->
		<xsl:variable name="soapaction"><xsl:value-of select="translate($soapaction,'&quot;', '')" /></xsl:variable>
		
		<xsl:variable name="response" select="dp:soap-call($wsURL,
										   $request/*,
										   null,
										   0,
										   $soapaction,
										   $httpHeaders/*,
										   true(),
										   120
										  )"/>
		<xsl:variable name="mti" select="substring-before( $response, '|' )" />
		<xsl:variable name="response1" select="substring-after( $response, '|' )" />
		<xsl:variable name="Primary_Account_NumberF02" select="substring-before( $response1, '|' )" />
		<xsl:variable name="response2" select="substring-after( $response1, '|' )" />
		<xsl:variable name="Processing_Code" select="substring-before( $response2, '|' )" />
		<xsl:variable name="response3" select="substring-after( $response2, '|' )" />
		<xsl:variable name="Transaction_Amount" select="substring-before( $response3, '|' )" />
		<xsl:variable name="response4" select="substring-after( $response3, '|' )" />
		<xsl:variable name="Transmission_Date" select="substring-before( $response4, '|' )" />
		<xsl:variable name="response5" select="substring-after( $response4, '|' )" />
		<xsl:variable name="Audit_Number" select="substring-before( $response5, '|' )" />
		<xsl:variable name="response6" select="substring-after( $response5, '|' )" />
		<xsl:variable name="Merchant_Type" select="substring-before( $response6, '|' )" />
		<xsl:variable name="response7" select="substring-after( $response6, '|' )" />
		<xsl:variable name="Acquiring_Code" select="substring-before( $response7, '|' )" />
		<xsl:variable name="response8" select="substring-after( $response7, '|' )" />
		<xsl:variable name="Authorization_Code" select="substring-before( $response8, '|' )" />
		<xsl:variable name="response9" select="substring-after( $response8, '|' )" />
		<xsl:variable name="Response_Code" select="substring-before( $response9, '|' )" />
		<xsl:variable name="response10" select="substring-after( $response9, '|' )" />
		<xsl:variable name="TermId" select="substring-before( $response10, '|' )" />
		<xsl:variable name="response11" select="substring-after( $response10, '|' )" />
		<xsl:variable name="Service_code" select="substring-before( $response11, '|' )" />
		<xsl:variable name="response12" select="substring-after( $response11, '|' )" />
		<xsl:variable name="BillId" select="substring-before( $response12, '|' )" />
		<xsl:variable name="response13" select="substring-after( $response12, '|' )" />
		<xsl:variable name="AdditionalInformation" select="substring-before( $response13, '|' )" />	
		<xsl:variable name="Signature" select="substring-after( $response13, '|' )" />		
		
		
		<!--Kiem tra neu Response_Code rong nghia la trong Response Napas chi tra ve ma loi, khong theo format, khong co chu ky-->
		<xsl:variable name="Response_Code">
			<xsl:choose>
				<xsl:when test = "$Response_Code =''">
					<xsl:value-of select="$response" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Response_Code" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--Verify chu ky so-->
		<xsl:variable name="verifyResult">
			<xsl:choose>			
				<!--Neu responseCode = 00, 05, 13 Napas moi ky len response, do do truong hop nay verify chu ky so Napas -->
				<xsl:when test = "$Response_Code ='00' and  $Response_Code !='05' and $Response_Code !='13'">
		<xsl:variable name="Data"><xsl:value-of select="$mti" /><xsl:value-of select="$Primary_Account_NumberF02" /><xsl:value-of select="$Processing_Code" /><xsl:value-of select="$Transaction_Amount" /><xsl:value-of select="$Transmission_Date" /><xsl:value-of select="$Audit_Number" /><xsl:value-of select="$Merchant_Type" /><xsl:value-of select="$Acquiring_Code" /><xsl:value-of select="$Authorization_Code" /><xsl:value-of select="$Response_Code" /><xsl:value-of select="$TermId" /><xsl:value-of select="$Service_code" /><xsl:value-of select="$BillId" /><xsl:value-of select="$AdditionalInformation" /></xsl:variable>
		
		<xsl:variable name="request4Verify">
		<!--
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://sml.com.vn/xsd">
			   <soapenv:Header/>
			   <soapenv:Body>
				  <xsd:verify>
					 <xsd:data><xsl:value-of select="$Data" /></xsd:data>
					 <xsd:signature><xsl:value-of select="$Signature" /></xsd:signature>
				  </xsd:verify>
			   </soapenv:Body>
			</soapenv:Envelope>
		-->
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:smar="http://bian.scb.com.vn/SmartlinkSignatureGenerator/">
			   <soapenv:Header/>
			   <soapenv:Body>
				  <smar:verify>
					 <data><xsl:value-of select="$Data" /></data>
					 <signature><xsl:value-of select="$Signature" /></signature>
				  </smar:verify>
			   </soapenv:Body>
			</soapenv:Envelope>
		</xsl:variable>
	
		
		<xsl:variable name="httpHeaders4Verify">
			<header name="SOAPAction">http://bian.scb.com.vn/SmartlinkSignatureGenerator/validateSignature</header>
			<header name="Content-Type">text/xml;charset=UTF-8</header>
		</xsl:variable>
		
		<xsl:variable name="soapaction4Verify">http://bian.scb.com.vn/SmartlinkSignatureGenerator/validateSignature</xsl:variable>
		
					<xsl:variable name="response4Verify" select="dp:soap-call($wsURL4Sign,
											   $request4Verify/*,
											   null,
											   0,
											   $soapaction4Verify,
											   $httpHeaders4Verify/*,
											   true(),
											   120
											  )"/>
				
					<result><xsl:value-of select="$response4Verify"/></result>
				</xsl:when>
				<xsl:otherwise><!--Cac truong hop khac khong can kiem tra chu ky so -->
					<result>0</result>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
				
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sml="http://www.scb.com.vn/billpayment/sml">
		   <soapenv:Header/>
		   <soapenv:Body>
			  <sml:payBillResponse>
				 <ResponseCode>
					<xsl:choose>						
						<xsl:when test = "$verifyResult/result ='0'"> 
							<xsl:value-of select="$Response_Code" />
						</xsl:when>
						<xsl:otherwise><!--Sai chu ky so-->
							-1
						</xsl:otherwise>								
					</xsl:choose>
				 </ResponseCode>				 
				 <AuthorizationCode><xsl:value-of select="$Authorization_Code" /></AuthorizationCode>
				 <AdditionalInformation><xsl:value-of select="$AdditionalInformation" /></AdditionalInformation>				 
				 <Payload>
					<RequestData><xsl:value-of select="$request" /></RequestData>
					<ResponseData><xsl:value-of select="$response" /></ResponseData>
				 </Payload>				 
			  </sml:payBillResponse>
		   </soapenv:Body>
		</soapenv:Envelope>		
    </xsl:template>	
</xsl:stylesheet>