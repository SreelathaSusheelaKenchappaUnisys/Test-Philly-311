<xml>
	<getPropertySchedule>
<![CDATA[
			<xml xmlns:s="uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema">
				<s:Schema id="RowsetSchema">
					<s:ElementType name="row" content="eltOnly">
						<s:AttributeType name="CUNO" rs:number="1" rs:writeunknown="true">
							<s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
						</s:AttributeType>
						<s:AttributeType name="CLIENT" rs:number="2" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="40" rs:fixedlength="true"/>
						</s:AttributeType>
						<s:AttributeType name="SHYR" rs:number="3" rs:writeunknown="true">
							<s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
						</s:AttributeType>
						<s:AttributeType name="SHCD" rs:number="4" rs:writeunknown="true">
							<s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true" rs:maybenull="false"/>
						</s:AttributeType>
						<s:AttributeType name="SHOW" rs:number="5" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="40" rs:fixedlength="true"/>
						</s:AttributeType>
						<s:AttributeType name="FCCD" rs:number="6" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="float" dt:maxLength="8" rs:precision="15" rs:fixedlength="true"/>
						</s:AttributeType>
						<s:AttributeType name="CITY" rs:number="7" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="30"/>
						</s:AttributeType>
						<s:AttributeType name="ASN_START_DATE" rs:number="8" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="10"/>
						</s:AttributeType>
						<s:AttributeType name="ASN_END_DATE" rs:number="9" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="10"/>
						</s:AttributeType>
						<s:AttributeType name="SHOW_START_DATE" rs:number="10" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="4000"/>
						</s:AttributeType>
						<s:AttributeType name="SHOW_END_DATE" rs:number="11" rs:nullable="true" rs:writeunknown="true">
							<s:datatype dt:type="string" rs:dbtype="str" dt:maxLength="4000"/>
						</s:AttributeType>
						<s:extends type="rs:rowbase"/>
					</s:ElementType>
				</s:Schema>
				<rs:data>
					<z:row CUNO="1011" CLIENT="Acura                                   " SHYR="2012" SHCD="1612" SHOW="No Show                                 " FCCD="100122" CITY="Auburn Hills, MI" ASN_START_DATE="2012-01-04" ASN_END_DATE="2012-01-04" SHOW_START_DATE="2012-01-01" SHOW_END_DATE="2012-12-31"/>
					<z:row CUNO="1011" CLIENT="Acura                                   " SHYR="2012" SHCD="399386" SHOW="Sundance Film Festival                  " FCCD="479573" CITY="Park City, UT" ASN_START_DATE="2012-01-12" ASN_END_DATE="2012-01-30" SHOW_START_DATE="2012-01-19" SHOW_END_DATE="2012-04-15"/>
					<z:row CUNO="1011" CLIENT="Acura                                   " SHYR="2012" SHCD="487515" SHOW="MusiCares Person of the Year Tribute    " FCCD="7779" CITY="Los Angeles, CA" ASN_START_DATE="2012-02-08" ASN_END_DATE="2012-02-10" SHOW_START_DATE="2012-02-10" SHOW_END_DATE="2012-02-10"/>
				</rs:data>
			</xml>
]]>
	</getPropertySchedule>
	<getAccountInquiryResponse>
<![CDATA[
		BRANCH_NUMBER => 0000000020
		CONTRACT_NUMBER => 00000000915840911000
		CUST_REV_NUMBER => 025
		CUST_BRANCH => 0000000020
		CUST_NUMBER => 30000000000002834438
		COSIGN_REV_NUMBER => 
		COSIGN_BRANCH => 
		COSIGN_NUMBER => 
		REV_NUMBER => 121
		CROSS_COUNTRY => 
		BRANCH_NAME => PHILADELPHIA  BUSINESS CENTER
		SECTION_NUMBER => 00
		PPC_NUMBER => 000604
		PRIMARY_DLR_NUMBER => 34507
		DLR_NUMBER_FILLER => 
		LEASE_AGRMNT_NUMBER => 
		CONTRACT_DATE => 20100614
		PURCHASE_DATE => 20100621
		ACCOUNT_TYPE => STD RETAIL
		ACCOUNT_TYPE_LABEL => Standard retail
		ACCOUNT_SUBTYPE => FFPF
		ACCOUNT_SUBTYPE_LABEL => Fixed rate (U.S. only)
		DISPUTED_ACCOUNT_SPECIAL_HANDLING => 00
		DISPUTED_ACCOUNT_SPECIAL_HANDLING_LABEL => Blanks
		SPECIAL_CODES => nbspnbspnbspnbspnbspnbspnbspNnbspnbspnbspnbspnbspnbspnbspnbspnbspnbspLC
		SPECIAL_CODES_LABEL => 
		COLLECTION_STATUS => 
		COLLECTION_STATUS_LABEL => 
		STOP_WARN => 0
		STOP_WARN_LABEL => 
		STOP_WARN_COMMENT => 
		BANKRUPTCY => 407
		BANKRUPTCY_LABEL => Bankruptcy - Chapter 7 (U.S.)
		PREV_BANKRUPTCY => 0
		PREV_BANKRUPTCY_LABEL => 
		MISC_FOLLOW_UP => X
		MISC_FOLLOW_UP_LABEL => Active miscellaneous follow-up
		RETURN_TYPE => 
		RETURN_TYPE_LABEL => 
		CUST.CUST_ADDRESS => PO BOX 355
		CUST.CUST_BUS_PHONE => 003023495275
		CUST.CUST_CITY => GREENWOOD
		CUST.CUST_COUNTY => SUSSEX
		CUST.CUST_COUNTRY => USA
		CUST.CUST_HME_PHONE => 
		CUST.CUST_NAME => JOHN SMITH
		CUST.CUST_SSN => 778053979
		CUST.CUST_STATE => DE
		CUST.CUST_STATE_LABEL => DELAWARE
		CUST.CUST_SUBTYPE => 
		CUST.CUST_SUBTYPE_LABEL => 
		CUST.CUST_TIC => S
		CUST.CUST_TIC_LABEL => Social Security Number
		CUST.CUST_WARNING => 
		CUST.CUST_ZIP => 19950
		COSIGN.COSIGN_NAME => 
		COSIGN.COSIGN_RELATIONSHIP => 
		COSIGN.COSIGN_RELATIONSHIP_LABEL => 
		COSIGN.COSIGN_SSN => 000000000
		COSIGN.COSIGN_TIC => 
		COSIGN.COSIGN_TIC_LABEL => 
		COSIGN.COSIGN_ADDRESS => 
		COSIGN.COSIGN_CITY => 
		COSIGN.COSIGN_STATE => 
		COSIGN.COSIGN_STATE_LABEL => 
		COSIGN.COSIGN_COUNTY => 
		COSIGN.COSIGN_ZIP => 
		COSIGN.COSIGN_COUNTRY => 
		COSIGN.COSIGN_HME_PHONE => 
		COSIGN.COSIGN_BUS_PHONE => 
		COSIGN.COSIGN_SUBTYPE => 
		COSIGN.COSIGN_SUBTYPE_LABEL => 
		BILLING.BILLING_NAME => SAME AS PRIMARY CUSTOMER
		BILLING.BILLING_RELATIONSHIP => BUY
		BILLING.BILLING_RELATIONSHIP_LABEL => Buyer (default)
		BILLING.BILLING_ADDRESS => 
		BILLING.BILLING_CITY => 
		BILLING.BILLING_STATE => 
		BILLING.BILLING_STATE_LABEL => 
		BILLING.BILLING_ZIP => 
		BILLING.BILLING_COUNTRY => 
		BILLING.BILLING_COUNTRY_LABEL => 
		VIN => 3GTRKVE38AG171545
		VEHICLE_DESCRIPTION => N10 GMC SIERRA
		LICENSE_PLATE => MI ABC1234
		TITLE_STATUS => 1
		TITLE_STATUS_LABEL => Received correction in process
		GARAGING.GARAGING_EFFECTIVE_DATE => 
		GARAGING.GARAGING_ADDRESS => 
		GARAGING.GARAGING_CITY => 
		GARAGING.GARAGING_STATE => 
		GARAGING.GARAGING_STATE_LABEL => 
		GARAGING.GARAGING_COUNTY => 
		GARAGING.GARAGING_ZIP => 
		GARAGING.GARAGING_COUNTRY => 
		ASSIGNEE => 
		ASSIGNEE_LABEL => 
		TAX_LOCATION => 
		TAX_LOCATION_LABEL => 
		ANTICIPATED_USE => 
		BASE_PAYMENT => 
		SECURITY_DEPOSIT => 
		REGISTRATION_EXPIRATION => 
		REGISTRATION_CODE => 
		REGISTRATION_CODE_LABEL => Customer pays registration fees (default)
		LASTPAY.LASTPAY_DATE => 20120612
		LASTPAY.LASTPAY_AMOUNT => +0.00
		LASTPAY.LASTPAY_PRINCIPAL => +1312.00
		LASTPAY.LASTPAY_EFFECTIVE_DATE => 00000000
		LASTPAY.LASTPAY_FIC => +0.00
		LASTPAY.LASTPAY_CODE => 
		LASTPAY.LASTPAY_CODE_LABEL => 
		LASTPAY.LASTPAY_UNPAID_CHRGS => +0.00
		LASTPAY.LASTPAY_DI_PAID => +0.00
		LASTPAY.LASTPAY_LATE_CHARGES => +0.00
		PAP_RETURN_DATE => 00000000
		PAP_RETURN_CODE => 
		PAP_RETURN_CODE_LABEL => 
		NEXTPAY_DATE => 20120129
		NEXTPAY_AMOUNT => +364.79
		SCHEDULED_PAYMENT => +558.93
		NEXTPAY_EXTENSION_FEE => +0.00
		TXN_SUMMARY => 00
		TXN_SUMMARY_LABEL => 
		NEXTPAY_UNPAID_CHARGES => +0.00
		BILL_MEDIUM => S
		BILL_MEDIUM_LABEL => Statement
		NEXTPAY_LATE_CHARGES => +0.00
		BILL_STATUS => S
		BILL_STATUS_LABEL => Suspended
		BILL_STATUS_COMMENT => 
		ON_DEMAND_BILLING => 
		ON_DEMAND_BILLING_LABEL => 
		PROMISE_DATE => 00000000
		PROMISE_COMMENT => 
		LAST_BILL_DATE => 20111101
		NXT_BILL_DATE => 20111207
		THRIFT_INDICATOR => N
		THRIFT_INDICATOR_LABEL => No
		PAP_TRANSIT_NUMBER => 
		PAP_ACCOUNT_NUMBER => 
		PAP_ACCOUNT_NAME => 
		PAP_STATUS => 5
		PAP_STATUS_LABEL => New volume 1st solicitation sent
		PAP_STATUS_DATE => 20100621
		DEPOSIT_PREFERENCE => 
		LAST_REVISION_DATE => 0000
		NUMBER_OF_EXTENSIONS => 000
		NUMBER_OF_RENEWALS => 000
		OVER_THIRTY => 002
		OVER_SIXTY => 000
		OVER_NINETY => 001
		PAST_DUE_HISTORY => 010140000000000
		ORIGINAL_OSB => +40242.50
		CURRENT_OSB => +29987.62
		ORIGINAL_PAYMENT => +558.93
		TERM => 00072
		REMAINING_TERM => 054
		APR => 
		SCHEDULED_END_DATE => 00000000
		FFP_FINAL_PAYMENT => 20161129
		DEALER.DEALER_NAME => PRICE BUICK-GMC, INC.
		DEALER.DEALER_ADDRESS => 2016 N. SALISBURY BLVD
		DEALER.DEALER_CITY => SALISBURY
		DEALER.DEALER_STATE => MD
		DEALER.DEALER_ZIP => 21801
		DEALER.DEALER_PHONE => 4107421106
		DEALER.DEALER_FAX => 4107424722
		PRIN_DEFICIENCY_DUE => 
		TOT_UNPD_CHARGES_DUE => 
		TOT_LATE_CHRGS_DUE => 
		TOT_PAYMENT_DUE => 
		COLL_ACTIVITY_DATE_ONE => 
		COLL_ACTIVITY_ACTION_ONE => 
		COLL_ACTIVITY_COMMENT_ONE => 
		COLL_ACTIVITY_DATE_TWO => 
		COLL_ACTIVITY_ACTION_TWO => 
		COLL_ACTIVITY_COMMENT_TWO => 
		DEALER_STATUS => PP
		DEALER_STATUS_LABEL => PLATINUM PLUS
		POWER_OF_ATTRNY => 
		POWER_OF_ATTRNY_LABEL => GMAC does not have possession of a POA
		PREV_DAMAGE_CODE => 
		PREV_DAMAGE_CODE_LABEL => No Damage
		PREV_DAMAGE_AMT => 000000
		TERM_REPO_STATUS => 000
		TERM_REPO_STATUS_LABEL => 
		EPDP_STATUS => 
		EPDP_STATUS_LABEL => 
		CISCO => 
		PRIVACY_OPT_OUT => 
		PRIVACY_OPT_OUT_LABEL => Opt-in - share personal information
		AFF_PRIV_OPT => 
		CUST_TYPE => I
		CUST_TYPE_LABEL => Individual
		COSIGN_TYPE => 
		COSIGN_TYPE_LABEL => 
		CYCLE_DATE => 20130429
		BANK_ACCOUNT_TYPE => 
		BANK_ACCOUNT_TYPE_LABEL => 
		PAP_IN_PROCESS => 
		PAP_IN_PROCESS_LABEL => 
		ARC_NUMBER => 0000000000
		COMMON_CUST_NBR => 
		LASTPAY_EXT_PAID => +0.00
		TERM_STATUS => 
		TERM_STATUS_LABEL => 
		BRANCH_COUNTRY => USA
		SML_INDICATOR => 
		SML_INDICATOR_LABEL => Account is not a plus account
		MCSP_INDICATOR => N
		MCSP_INDICATOR_LABEL => MCSP not applicable
		VEHICLE_IND => X
		LP_SL.LP_SL_POST_DATE => 20120612
		LP_SL.LP_SL_CODE => 
		LP_SL.LP_SL_CODE_LABEL => 
		LP_SL.LP_SL_AMOUNT => +1312.00
		LP_SL.LP_SL_SALES_TAX => +0.00
		LP_SL.LP_SL_GST => +0.00
		LP_SL.LP_SL_PPT => +0.00
		LP_SL.LP_SL_SERVICE_CHARGE => +0.00
		LP_SL.LP_SL_MONTHLY_USE => +0.00
		LP_SL.LP_SL_LATE_CHARGE_PAID => +0.00
		LP_SL.LP_SL_EXTENSION_FEE_PAID => +0.00
		LP_SL.LP_SL_OTHER_MONTHLY_PAID => +0.00
		LP_SL.LP_SL_OTHER_CHARGES_PAID => +0.00
		LP_SL.LP_SL_LINE_TOTAL => +1312.00
		ANTICIPATED_INDICATOR => 
		PAST_DUE_INDICATOR => 
		PPT_STATE_INDICATOR => 
		SB_BALLOON => 
		RESIDUAL => 
		REGULATORY_STATE_CODE => MD
		REGULATORY_STATE_CODE_LABEL => MARYLAND
		TQ_ANTICIPATED_ODOMETER => 
		PPC_NAME => PAYMENT PROCESSING CENTER
		PPC_ADDRESS => PO BOX 78234
		PPC_CITY => PHOENIX
		PPC_STATE => AZ
		PPC_ZIP => 850628234
		CUST_BIRTH_DATE => 19660309
		CBYR_BIRTH_DATE => 
		BASE_PAYMENT_GST => 
		BASE_PAYMENT_STX => 
		FI_SERVICE_IND => 00
		FI_SERVICE_IND_LABEL => GMAC
		ACCNT_TYPE => I
		ACCNT_TYPE_LABEL => Interest Bearing (FFP in US and Canada)
		ACCNT_SUBTYPE => 
		ACCNT_SUBTYPE_LABEL => 
		PRIME_IND => 
		PRIME_IND_LABEL => Prime Account
		EXT_REF_ID => 
		EXT_APP_NUM => 
		DIS_SRC => 
		DIS_SRC_LABEL => 
		CONV_ACCT_SRC => 
		CONV_DATE => 00000000
		SRC_ACCT_NUM => 
		NO_NOTICE => X
		NO_NOTICE_DT => 00000000
		NO_NOTICE_ID => ********
		NO_NOTICE_CMNT => 
		STOP_WARN_DATE => 0000
		BANKRUPTCY_DATE => 20120612
		COLLATERAL_YEAR => 2010
		COLLATERAL_MAKE => 007
		COLLATERAL_MODEL => 
		COMMON_CUST_IND => 
		CUST_DEFICIENCY => 
		CUST_LANG_CODE => 00
		LC_STATUS_CODE => S
		BILLING_COUNTY => SUSSEX
		NUM_EXT_AT_MAT => 00
		ANT_MTHLY_MILEAGE => 
		BEGINNING_ODOMETER => 
		AI_LMI_PPT => 
		AI_LMI_SERVICE_CHARGE => 
		AI_LMI_MTHLY_MILE_CHG => 
		AI_LMI_OTH_LSE_CHG => 
		MEDIA_CD => 1
		AUTOPAY_FLAG => 
		COMMON_BRND_IND_NUM => C01GM GM 0000I
		CUST_HM_PHN_TYPE_CD => 00
		CUST_HM_PHN_PERMISSION_CD => 00000
		CUST_BUS_PHN_TYPE_CD => 01
		CUST_BUS_PHN_PERMISSION_CD => 00021
		CUST_CELL_PHN_PERMISSION_CD => 00000
		CELL_PHONE => 
		CO_CUST_HM_PHN_TYPE_CD => 
		CO_CUST_HM_PHN_PERMISSION_CD => 
		CO_CUST_BUS_PHN_TYPE_CD => 
		CO_CUST_BUS_PHN_PERMISSION_CD => 
		CO_CUST_CELL_PHN => 
		CO_CUST_CELL_PHN_PERMISSION_CD => 
		BILLING_ADDRESS_CORR_CODE => 000
		CUST_PRMY_ADDR_CORR_CD => 000
		CO_SIGNER_PRMY_ADDR_CORR_CD => 
		ONLINE_PROFILE_INDICATOR => P
		FILLER_RESERVED => L
		FIC.OCC_COUNTER => 0
		PAST_DUE.OCC_COUNTER => 0
		FEE.OCC_COUNTER => 0
		BUSINESS_ASSOCIATE.OCC_COUNTER => 0]]>
	</getAccountInquiryResponse>
	<ContractCSV>
		<![CDATA[
			ActivityDate, ActivityDateTime, DurationInMinutes, Location
			2014-09-04, 2014-09-04 14:50:00, 30, Detroit
			2014-09-04, 2014-09-04 14:50:00, 30, Philadelphia
			2014-09-04, 2014-09-04 14:50:00, 30, Denver
		]]>
	</ContractCSV>
</xml>
