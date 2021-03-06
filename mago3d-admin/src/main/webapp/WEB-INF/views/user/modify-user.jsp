<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<%@ include file="/WEB-INF/views/common/config.jsp" %>

<!DOCTYPE html>
<html lang="${accessibility}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width">
	<title>${sessionSiteName }</title>
	<link rel="stylesheet" href="/css/${lang}/font/font.css" />
	<link rel="stylesheet" href="/images/${lang}/icon/glyph/glyphicon.css" />
	<link rel="stylesheet" href="/externlib/normalize/normalize.min.css" />
	<link rel="stylesheet" href="/externlib/jquery-ui/jquery-ui.css" />
	<link rel="stylesheet" href="/css/${lang}/style.css" />
</head>

<body>
	<%@ include file="/WEB-INF/views/layouts/header.jsp" %>
	<%@ include file="/WEB-INF/views/layouts/menu.jsp" %>
	
	<div class="site-body">
		<div class="container">
			<div class="site-content">
				<%@ include file="/WEB-INF/views/layouts/sub_menu.jsp" %>
				<div class="page-area">
					<%@ include file="/WEB-INF/views/layouts/page_header.jsp" %>
					
					<div class="page-content">
						<div class="content-desc u-pull-right"><span class="icon-glyph glyph-emark-dot color-warning"></span><spring:message code='check'/></div>
						<div class="tabs">
							<ul>
								<li><a href="#user_info_tab"><spring:message code='user.input.information'/></a></li>
							</ul>
							<div id="user_info_tab">
								<form:form id="userInfo" modelAttribute="userInfo" method="post" onsubmit="return false;">
									<form:hidden path="user_id"/>
								<table class="input-table scope-row">
									<col class="col-label" />
									<col class="col-input" />
									<tr>
										<th class="col-label" scope="row">
											<form:label path="user_id"><spring:message code='id'/></form:label>
											<span class="icon-glyph glyph-emark-dot color-warning"></span>
										</th>
										<td class="col-input">
											${userInfo.user_id }
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="user_group_name"><spring:message code='user.group.usergroup'/></form:label>
											<span class="icon-glyph glyph-emark-dot color-warning"></span>
										</th>
										<td class="col-input">
											<form:hidden path="user_group_id" />
				 							<form:input path="user_group_name" cssClass="m" readonly="true" />
											<input type="button" id="user_group_buttion" value="<spring:message code='user.group.usergroup'/>" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="user_name"><spring:message code='name'/></form:label>
											<span class="icon-glyph glyph-emark-dot color-warning"></span>
										</th>
										<td class="col-input">
											<form:input path="user_name" class="m" />
					  						<form:errors path="user_name" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="old_password"><spring:message code='old.password'/></form:label>
											<span class="icon-glyph glyph-emark-dot color-warning"></span>
										</th>
										<td class="col-input">
											<form:password path="old_password" class="m" />
											<form:errors path="old_password" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="password"><spring:message code='new.password'/></form:label>
										</th>
										<td class="col-input">
											<form:password path="password" class="m" />
											<span class="table-desc"><spring:message code='user.information.modify.password'/></span>
											<form:errors path="password" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="password_confirm"><spring:message code='new.password.check'/></form:label>
										</th>
										<td class="col-input">
											<form:password path="password_confirm" class="m" />
											<span class="table-desc"><spring:message code='user.input.upper.case'/> ${policy.password_eng_upper_count}, <spring:message code='user.input.lower.case'/> ${policy.password_eng_lower_count},
												 <spring:message code='user.input.number'/> ${policy.password_number_count}, <spring:message code='user.input.special.characters'/> ${policy.password_special_char_count} <spring:message code='user.input.special.characters.need'/>.
												 ${policy.password_min_length} ~ ${policy.password_max_length}<spring:message code='user.input.do'/></span>
											<form:errors path="password_confirm" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="telephone1"><spring:message code='phone.number'/></form:label>
										</th>
										<td class="col-input">
											<form:input path="telephone1" class="xs" maxlength="3" />
											<span class="delimeter dash">-</span>
											<form:input path="telephone2" class="xs" maxlength="4" />
											<span class="delimeter dash">-</span>
											<form:input path="telephone3" class="xs" maxlength="4" />
											<form:errors path="telephone1" cssClass="error" />
											<form:errors path="telephone2" cssClass="error" />
											<form:errors path="telephone3" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="mobile_phone1"><spring:message code='mobile'/></form:label>
										</th>
										<td class="col-input">
											<form:input path="mobile_phone1" class="xs" maxlength="3" />
											<span class="delimeter dash">-</span>
											<form:input path="mobile_phone2" class="xs" maxlength="4" />
											<span class="delimeter dash">-</span>
											<form:input path="mobile_phone3" class="xs" maxlength="4" />
											<form:errors path="mobile_phone1" cssClass="error" />
											<form:errors path="mobile_phone2" cssClass="error" />
											<form:errors path="mobile_phone3" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="email1"><spring:message code='email'/></form:label>
										</th>
										<td class="col-input">
											<form:input path="email1" class="s" />
											<span class="delimeter at">@</span>
											<form:input path="email2" class="s" />
											<select id="email3" name="email3" class="selectBoxClass">
				               		 			<option value="0"><spring:message code='direct.input'/></option>
	<c:if test="${!empty emailCommonCodeList }">
		<c:forEach var="commonCode" items="${emailCommonCodeList}" varStatus="status">
				               		 			<option value="${commonCode.code_value }">${commonCode.code_value }</option>
		</c:forEach>
	</c:if>
											</select>
											<form:errors path="email1" cssClass="error" />
											<form:errors path="email2" cssClass="error" />
											<form:errors path="email" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="messanger"><spring:message code='messenger'/></form:label>
										</th>
										<td class="col-input">
											<form:input path="messanger" class="m" />
											<form:errors path="messanger" cssClass="error" />
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="status"><spring:message code='status'/></form:label>
										</th>
										<td class="col-input">
											<form:select path="status" cssClass="selectBoxClass">
												<option value="0"><spring:message code='user.group.in.use'/></option>
												<option value="1"><spring:message code='user.group.stop.use'/></option>
												<option value="2"><spring:message code='user.group.lock.password'/></option>
												<option value="3"><spring:message code='user.group.dormancy'/></option>
												<option value="4"><spring:message code='user.group.expires'/></option>
												<option value="5"><spring:message code='user.group.delete'/></option>
												<option value="6"><spring:message code='user.group.temporary.password'/></option>
											</form:select>
										</td>
									</tr>
									<tr>
										<th class="col-label" scope="row">
											<form:label path="user_insert_type"><spring:message code='user.information.register.guide'/></form:label>
										</th>
										<td class="col-input">
											<form:select path="user_insert_type" cssClass="selectBoxClass">
												<option value="SELF"><spring:message code='user.information.register.admin'/></option>
											</form:select>
										</td>
									</tr>
								</table>
								<div class="button-group">
									<div class="center-buttons">
										<input type="submit" value="<spring:message code='save'/>" onclick="updateUserInfo();" />
										<a href="/user/list-user.do?${listParameters}" class="button"><spring:message code='list'/></a>
									</div>
								</div>
								</form:form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@ include file="/WEB-INF/views/layouts/footer.jsp" %>
	
	<!-- Dialog -->
	<div class="dialog" title="<spring:message code='user.group.usergroup'/>">
		<div class="dialog-user-group">
			<ul>
<c:if test="${!empty userGroupList }">
	<c:set var="groupDepthValue" value="0" />
	<c:forEach var="userGroup" items="${userGroupList }" varStatus="status">
		<c:if test="${groupDepthValue eq '0' && userGroup.depth eq 1 }">
				<li>
					<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
					<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '1' && userGroup.depth eq 1 }">
				</li>
				<li>
					<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
					<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '1' && userGroup.depth eq 2 }">
					<ul>
						<li>
							<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
							<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '2' && userGroup.depth eq 1 }">
						</li>
					</ul>
				</li>
				<li>
					<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
					<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '2' && userGroup.depth eq 2 }">
						</li>
						<li>
							<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
							<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '2' && userGroup.depth eq 3 }">
							<ul style="padding-left: 30px;">
								<li>
									<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
									<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>
		<c:if test="${groupDepthValue eq '3' && userGroup.depth eq 1 }">
								</li>
							</ul>
						</li>
					</ul>
				</li>
				<li>
					<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
					<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>		
		<c:if test="${groupDepthValue eq '3' && userGroup.depth eq 2 }">
								</li>
							</ul>
						</li>
						<li>
							<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
							<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>			
		<c:if test="${groupDepthValue eq '3' && userGroup.depth eq 3 }">
								</li>
								<li>
									<input type="radio" id="radio_group_${userGroup.user_group_id }" name="radio_group" value="${userGroup.user_group_id }_${userGroup.group_name }" />
									<label for="radio_group_${userGroup.user_group_id }">${userGroup.group_name }</label>
		</c:if>	
		<c:if test="${userGroup.depth eq '3' && status.last }">
								</li>
							</ul>
						</li>
					</ul>
				</li>
		</c:if>
		<c:if test="${userGroup.depth eq '2' && status.last }">
						</li>
					</ul>
				</li>
		</c:if>
		<c:if test="${userGroup.depth eq '1' && status.last }">
				</li>
		</c:if>
		<c:set var="groupDepthValue" value="${userGroup.depth }" />			
	</c:forEach>
			</ul>
</c:if>
		</div>
			
		<div class="button-group">
			<input type="submit" id="button_groupSelect" name="button_groupSelect" value="<spring:message code='select'/>" />
		</div>
	</div>
	
<script type="text/javascript" src="/externlib/jquery/jquery.js"></script>
<script type="text/javascript" src="/externlib/jquery-ui/jquery-ui.js"></script>	
<script type="text/javascript" src="/js/${lang}/common.js"></script>
<script type="text/javascript" src="/js/${lang}/message.js"></script>
<script type="text/javascript" src="/js/navigation.js"></script>
<script type="text/javascript">
	// 0은 비표시, 1은 표시
	var userDeviceArray = new Array("0", "0", "0", "0", "0", "0");
	var userDeviceCount = 0;
	$(document).ready(function() {
		$( ".tabs" ).tabs();
		initJqueryCalendar();
		initUserDevice();
		
		var email2 = "${userInfo.email2}";
		if(email2 == "") email2 = "0";
		$("#email3").val(email2);
/* 		$("#email3").selectmenu("refresh"); */
		
		var userStatus = "${userInfo.status}";
		if(userStatus != null && userStatus != "") {
			$("#status").val("${userInfo.status}");
		}
		var userInsertType = "${userInfo.user_insert_type}";
		if(userInsertType != null && userInsertType != "") {
			$("#user_insert_type").val("${userInfo.user_insert_type}");
		}
		
		$("[name=sso_use_yn]").filter("[value='${userInfo.sso_use_yn}']").prop("checked",true);
		
		
		
		initUserDevice();
		$( ".select" ).selectmenu();
	});
	
	// 그룹 선택
	$( "#user_group_buttion" ).on( "click", function() {
		dialog.dialog( "open" );
	});
	var dialog = $( ".dialog" ).dialog({
		autoOpen: false,
		height: 600,
		width: 600,
		modal: true,
		resizable: false
	});
	
	// 디바이스 초기화
	function initUserDevice() {
		if("${userDevice.device_name1}" == null || "${userDevice.device_name1}" == "") {
			$("#user_device1").css("display", "none");
			userDeviceArray[0] = "0";
			userDeviceCount--;
		}
		if("${userDevice.device_name2}" == null || "${userDevice.device_name2}" == "") {
			$("#user_device2").css("display", "none");
			userDeviceArray[1] = "0";
			userDeviceCount--;
		}
		if("${userDevice.device_name3}" == null || "${userDevice.device_name3}" == "") {
			$("#user_device3").css("display", "none");
			userDeviceArray[2] = "0";
			userDeviceCount--;
		}
		if("${userDevice.device_name4}" == null || "${userDevice.device_name4}" == "") {
			$("#user_device4").css("display", "none");
			userDeviceArray[3] = "0";
			userDeviceCount--;
		}
		if("${userDevice.device_name5}" == null || "${userDevice.device_name5}" == "") {
			$("#user_device5").css("display", "none");
			userDeviceArray[4] = "0";
			userDeviceCount--;
		}
		if("${userDevice.device_name1}" != null && "${userDevice.device_name1}" != "") {
			$("#device_type1").val("${userDevice.device_type1}");
			$("#use_yn1").val("${userDevice.use_yn1}");
		}
		if("${userDevice.device_name2}" != null && "${userDevice.device_name2}" != "") {
			$("#device_type2").val("${userDevice.device_type2}");
			$("#use_yn2").val("${userDevice.use_yn2}");
		}
		if("${userDevice.device_name3}" != null && "${userDevice.device_name3}" != "") {
			$("#device_type3").val("${userDevice.device_type3}");
			$("#use_yn3").val("${userDevice.use_yn3}");
		}
		if("${userDevice.device_name4}" != null && "${userDevice.device_name4}" != "") {
			$("#device_type4").val("${userDevice.device_type4}");
			$("#use_yn4").val("${userDevice.use_yn4}");
		}
		if("${userDevice.device_name5}" != null && "${userDevice.device_name5}" != "") {
			$("#device_type5").val("${userDevice.device_type5}");
			$("#use_yn5").val("${userDevice.use_yn5}");
		}
	}
	
	// 아이디 중복 확인
	$( "#user_duplication_buttion" ).on( "click", function() {
		var userId = $("#user_id").val();
		if (userId == "") {
			alert(JS_MESSAGE["user.id.empty"]);
			$("#user_id").focus();
			return false;
		}
		var info = "user_id=" + userId;
		$.ajax({
			url: "/user/ajax-user-id-duplication-check.do",
			type: "POST",
			data: info,
			cache: false,
			dataType: "json",
			success: function(msg){
				if(msg.result == "success") {
					if(msg.duplication_value != "0") {
						alert(JS_MESSAGE["user.id.duplication"]);
						$("#user_id").focus();
						return false;
					} else {
						alert(JS_MESSAGE["user.id.enable"]);
						$("#duplication_value").val(msg.duplication_value);
					}
				} else {
					alert(JS_MESSAGE[msg.result]);
				}
			},
			error: function() {
				alert(JS_MESSAGE["ajax.error.message"]);
			}
		});
	});
	
	// 그룹 선택
	$( "#button_groupSelect" ).on( "click", function() {
		var radioObj = $(":radio[name=radio_group]:checked").val();
		if (!radioObj) {
			alert(JS_MESSAGE["check.group.required"]);
	        return false;
	    } else {
	    	var splitValues = radioObj.split("_");
	    	var userGroupName = "";
	    	for(var i = 1; i < splitValues.length; i++) {
	    		userGroupName = userGroupName + splitValues[i];
	    		if(i != splitValues.length - 1) {
	    			userGroupName = userGroupName + "_";
	    		}
			}	    	
	    	$("#user_group_id").val(splitValues[0]);
			$("#user_group_name").val(userGroupName);
			dialog.dialog( "close" );
	    }
	});
	
	// 사용자 정보 저장
	var updateUserInfoFlag = true;
	function updateUserInfo() {
		if(updateUserInfoFlag) {
			if (checkUserInfo() == false) {
				return false;
			}
			
			updateUserInfoFlag = false;
			var info = $("#userInfo").serialize();
			$.ajax({
				url: "/user/ajax-update-user-info.do",
				type: "POST",
				data: info,
				cache: false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						$("#reloadMobilePhone").html(msg.maskingMobilePhone);
						$("#reloadEmail").html(msg.maskingEmail);
						$("#reloadMessanger").html(msg.messanger);
						alert(JS_MESSAGE["user.info.update"]);
					} else {
						if(msg.result == "user.password.exception.char") {
							alert(JS_MESSAGE["user.password.exception.char.message1"] + "${passwordExceptionChar}" + JS_MESSAGE["user.password.exception.char.message2"]);
						} else {
							alert(JS_MESSAGE[msg.result]);							
						}
					}
					updateUserInfoFlag = true;
				},
				error:function(request,status,error){
			        alert(JS_MESSAGE["ajax.error.message"]);
			        updateUserInfoFlag = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		}
	}
	
	function checkUserInfo() {
		if ($("#user_id").val() == "") {
			alert(JS_MESSAGE["user.id.empty"]);
			$("#user_id").focus();
			return false;
		}
		if ($("#user_group_id").val() == "") {
			alert(JS_MESSAGE["user.group.id.empty"]);
			$("#user_group_id").focus();
			return false;
		}
		if ($("#user_name").val() == "") {
			alert(JS_MESSAGE["user.name.empty"]);
			$("#user_name").focus();
			return false;
		}
		
		var old_password = $("#old_password").val();
		if(old_password == "") {
			alert(JS_MESSAGE["user.old.password.exception"]);
			$("#old_password").focus();
			return false;
		}
		if(old_password.length < parseInt("${policy.password_min_length}")
				|| old_password.length > parseInt("${policy.password_max_length}")) {
			alert(JS_MESSAGE["user.password.length"] + " ${policy.password_min_length} ~ ${policy.password_max_length}");
			$("#old_password").focus();
			return false;
		}
		
		var password = $("#password").val();
		var password_confirm = $("#password_confirm").val();
		if(old_password == password_confirm) {
			alert(JS_MESSAGE["user.password.same"]);
			$("#password").focus();
			return false;
		}
		if(password != "" && password_confirm != "") {
			if($("#password").val().length < parseInt("${policy.password_min_length}")
					|| $("#password").val().length > parseInt("${policy.password_max_length}")) {
				alert(JS_MESSAGE["user.password.length"] + " ${policy.password_min_length} ~ ${policy.password_max_length}");
				$("#password").focus();
				return false;
			}
			if(password.search(/\s/) != -1) { 
				alert(JS_MESSAGE["user.password.invalid"]);
				$("#password").focus();
				return false; 
			}
			if(password != password_confirm) {
				alert(JS_MESSAGE["user.group.password.not.same"]);
				$("#password").focus();
				return false;
			}	
		} 
		
		var telephone_regExp1 = /^\d{2,3}$/;
		var telephone1 = $("#telephone1").val();
		if (telephone1 != null && telephone1 != "" && !telephone_regExp1.test(telephone1)) {
			alert(JS_MESSAGE["user.group.phone.number.type"]);
			$("#telephone1").focus();
			return false;
		}
		var telephone_regExp2 = /^\d{3,4}$/;
		var telephone2 = $("#telephone2").val();
		if (telephone2 != null && telephone2 != "" && !telephone_regExp2.test(telephone2)) {
			alert(JS_MESSAGE["user.group.phone.number.type"]);
			$("#telephone2").focus();
			return false;
		}
		var telephone_regExp3 = /^\d{4,4}$/;
		var telephone3 = $("#telephone3").val();
		if (telephone3 != null && telephone3 != "" && !telephone_regExp3.test(telephone3)) {
			alert(JS_MESSAGE["user.group.phone.number.type"]);
			$("#telephone3").focus();
			return false;
		}
		var mobilephone_regExp1 = /^\d{3,3}$/;
		var mobile_phone1 = $("#mobile_phone1").val();
		if (mobile_phone1 != null && mobile_phone1 != "" && !mobilephone_regExp1.test(mobile_phone1)) {
			alert(JS_MESSAGE["user.group.mobiler.type"]);
			$("#mobile_phone1").focus();
			return false;
		}
		var mobilephone_regExp2 = /^\d{3,4}$/;
		var mobile_phone2 = $("#mobile_phone2").val();
		if (mobile_phone2 != null && mobile_phone2 != "" && !mobilephone_regExp2.test(mobile_phone2)) {
			alert(JS_MESSAGE["user.group.mobiler.type"]);
			$("#mobile_phone2").focus();
			return false;
		}
		var mobilephone_regExp3 = /^\d{4,4}$/;
		var mobile_phone3 = $("#mobile_phone3").val();
		if (mobile_phone3 != null && mobile_phone3 != "" && !mobilephone_regExp3.test(mobile_phone3)) {
			alert(JS_MESSAGE["user.group.mobiler.type"]);
			$("#mobile_phone3").focus();
			return false;
		}
		var email_regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		if ($("#email1").val() != null && $("#email1").val() != "" && $("#email2").val() != null && $("#email2").val() != "") {
			if (!email_regExp.test($("#email1").val() + "@" + $("#email2").val())) {
				alert(JS_MESSAGE["user.group.email.type"]);
				return false;
			}
		}
	}
	

	
	// 사용자 디바이스 정보 저장
	var updateUserDeviceFlag = true;
	function updateUserDevice() {
		if (checkUserDevice() == false) {
			return false;
		}
		if(updateUserDeviceFlag) {
			updateUserDeviceFlag = false;
			var info = $("#userDevice").serialize() + "&user_id=" + $("#user_id").val();		
			$.ajax({
				url: "/user/ajax-update-user-device.do",
				type: "POST",
				data: info,
				cache: false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						alert(JS_MESSAGE["update"]);
					} else {
						alert(JS_MESSAGE[msg.result]);
					}
					updateUserDeviceFlag = true;
				},
				error:function(request,status,error){
			        alert(JS_MESSAGE["ajax.error.message"]);
			        updateUserDeviceFlag = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		}
	}
	
	function checkUserDevice() {
		for(var i=1; i<userDeviceCount + 1; i++) {
			if(document.getElementById("user_device" + i).style.display == "") {
				if($("#device_name" + i).val() == null || $("#device_name" + i).val() == "") {
					alert(JS_MESSAGE["use.device.name.input"]);
					$("#device_name" + i).focus();
					return false;
				}
			}
		}
		
		for(var i=1; i<userDeviceCount + 1; i++) {
			if(!isIP($("#device_ip" + i).val())) {
				alert(JS_MESSAGE["input.ip"]);
				$("#device_ip" + i).focus();
				return false;
			}
		}
	}
	
	// 사용자 디바이스 추가
	function addUserDevice() {
		if(userDeviceArray[0] == "0") {
			$("#user_device1").css("display", "");
			userDeviceArray[0] = "1";
			userDeviceCount++;
		} else if(userDeviceArray[1] == "0") {
			$("#user_device2").css("display", "");
			userDeviceArray[1] = "1";
			userDeviceCount++;
		} else if(userDeviceArray[2] == "0") {
			$("#user_device3").css("display", "");
			userDeviceArray[2] = "1";
			userDeviceCount++;
		} else if(userDeviceArray[3] == "0") {
			$("#user_device4").css("display", "");
			userDeviceArray[3] = "1";
			userDeviceCount++;
		} else if(userDeviceArray[4] == "0") {
			$("#user_device5").css("display", "");
			userDeviceArray[4] = "1";
			userDeviceCount++;
		} else if(userDeviceArray[5] == "0") {
			userDeviceArray[5] = "1";
		}
		
		if(userDeviceArray[0] == "1" && userDeviceArray[1] == "1" && userDeviceArray[2] == "1"
				&& userDeviceArray[3] == "1" && userDeviceArray[4] == "1" && userDeviceArray[5] == "1") {
			alert(JS_MESSAGE["user.device.input.max.five"]);
		}
		userDeviceArray[5] = "0"
	}
	
	// 사용자 디바이스 삭제
	function removeUserDevice(idx) {
		var loopCount = userDeviceCount + 1;
		for(var i = idx; i < loopCount; i++) {
			if(i == loopCount - 1) {
				// 마지막의 경우 삭제하고 종료
				userDeviceArray[i-1] = "0";
				$("#device_name" + i).val("");
				$("#device_ip" + i).val("");
				document.getElementById("device_type" + i).selectedIndex = 0;
				document.getElementById("use_yn" + i).selectedIndex = 0;
				$("#user_device" + i).css("display", "none");
				userDeviceCount--;
				return;
			}
			
			$("#device_name" + i).val( $("#device_name" + (i + 1)).val() );
			$("#device_ip" + i).val( $("#device_ip" + (i + 1)).val() );
			document.getElementById("device_type" + i).selectedIndex = document.getElementById("device_type" + (i+1)).selectedIndex;
			document.getElementById("use_yn" + i).selectedIndex = document.getElementById("use_yn" + (i+1)).selectedIndex;
		}
	}
	
/* 	$( "#email3" ).selectmenu({
		change: function( event, ui ) {
			if($("#email3").val() != 0) {
				$("#email2").val($("#email3").val());
			} else {
				$("#email2").val("");
			}
		}
	}); */
</script>
</body>
</html>