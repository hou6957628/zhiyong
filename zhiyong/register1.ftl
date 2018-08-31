<!doctype html>
<html>
<head>
<meta charset="utf-8">
<!--可视区域的定义，如屏幕缩放等。告诉浏览器如何规范的渲染网页-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<!--ie和chrome中最佳的兼容模式-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--启用 webapp 模式, 会隐藏工具栏和菜单栏，和其它配合使用。-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--在webapp模式下，改变顶部状态条的颜色。-->
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<!--屏蔽电话号码-->
<meta name="format-detection" content="telephone=no">
<title>提钱快乐-注册</title>
<link href="${base}/resources/wap/cpas/css/base.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/wap/cpas/css/login.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/wap/cpas/css/colorbox.css" rel="stylesheet" type="text/css" />
</head>

<body class="loginpage">
<section>
	<!--页头-->
	<header class="header">
        <a href="javascript:history.back(-1);"><div class="icon"></div></a>
        <div class="title">新用户注册</div>
        </header>
        <!--页头结束-->

        <!--注册-->
        <div class="content">
		<form action="#" method="post" id="registerForm" class="form" style="background:none;">
			<ul>
				<li>
					<div class="input"><input type="text" value="" id="mobile" name="mobile" class="input-text" placeholder="请输入您的手机号码" /></div>
					<div class="note clear"><!--请输入您的手机号码--></div>
				</li>
				<li>
					<div class="input"><input type="password" value="" id="password" name="password" class="input-password" placeholder="请输入密码" /></div>
					<div class="note clear"><!--请输入密码--></div>
				</li>
				<li>
					<div class="input">
						<div class="pull-left"><input type="text" value="" id="captcha" name="captcha" class="input-yzm" placeholder="请输入验证码" /></div>
						<div class="pull-right"><input type="button" id="captchaButton" disableClassName="active" disablePromptValueSuffix="后重发" value="获取验证码" class="yzm-btn" /></div>
				    </div>
					<div class="note clear"></div>
				</li>
				<li>
					<div class="input"><input type="text" value="" id="recommemder" name="recommemder" class="input-tuijian" placeholder="请输入推荐人手机号码（选填）" /></div>
					<div class="note clear recommemder"><!--请输入您的手机号码--></div>
				</li>
			</ul>
			<div class="btn">
				[#if error??]
				<input type="button" value="立即注册" class="register-btn" />
				[#else]
				<input type="submit" value="立即注册" class="register-btn" />
				[/#if]
			</div>
		</form>
	</div>
	
	<div class="hide">
		<div id="result" class="result-popup">
			<!--成功图标-->
			<div class="img" id="rstImg"><img src="${base}/resources/wap/cpas/images/success-icon.png" width="60" alt="" /></div>
			<h3 id="rstMsg">恭喜您，注册成功！</h3>
			<div class="btn"><input type="button" value="确认" onclick="rsb();" class="result-btn" /></div>
		</div>
	</div>
	
	<footer class="footer">
		<div class="close"><img src="${base}/resources/wap/cpas/images/close-icon.png" width="20" alt="" /></div>
		<div class="name pull-left">
			<img src="${base}/resources/wap/cpas/images/logo.png" width="40" alt="" title="" class="pull-left" />
			<div class="pull-left">
				<h3>提钱快乐</h3>
				<p>宜投通旗下—手机里的信用钱包</p>
			</div>
		</div>
		<div class="btn pull-right">
			<a id="download" href="#">立即下载</a>
		</div>
	</footer>
</section>
<script src="${base}/resources/wap/cpas/js/jquery-1.11.3.min.js"></script>
<script src="${base}/resources/wap/cpas/js/jquery.colorbox.js"></script>
[#--公共JS--]
<script src="${base}/resources/wap/cpas/js/common.js?version=${setting.basic.siteVersion}"></script>
[#-- RSA加密 --]
<script src="${base}/resources/lib/tools/rsa/jsbn.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/prng4.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/rng.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/rsa.min.js"></script>
<script src="${base}/resources/lib/tools/base/base64.min.js"></script>
[#-- validate 验证器 --]
<script src="${base}/resources/lib/validate/jquery.validate.min.js"></script>
<script src="${base}/resources/lib/validate/jquery.validate.method.min.js"></script>
[#if error??]
<script>
var g_url="";
$(function(){
	$(".recommemder").text("${error}");
	$(".register-btn").click(function(){
		$("#rstImg").html('<img src="${base}/resources/wap/cpas/images/fail-icon.png" width="60" alt="" />');
		$("#rstMsg").text("${error}");
		$.colorbox({
			href:"#result", 
			inline: true, 
			overlayClose:true, 
			width:"60%",
			height:"175px",
		});
	});
});

</script>
[#else]
<script>
var g_url="";
	$(".content").css("height",$(window).height()-50);
	$(".form").css("height",$(window).height()-70);
	$(function() {
		var $registerForm = $("#registerForm"),$captchaButton = $("#captchaButton"),$mobile=$("#mobile");
		$submit = $registerForm.find(":submit"),$password = $("#password"),$rePassword = $("#rePassword"),$captcha = $("#captcha"),rsaKey = new RSAKey();
		//rsaKey.setPublic(b64tohex(modulus), b64tohex(exponent));
		[#-- 表单验证 --]
		var $validate = $registerForm.validate({
			rules: {
				mobile: {
					required: true,
					pattern: /^1[3,4,5,7,8]\d{9}$/,
					remote: {
						url: "${base}/api/customer/mobile",
						type: "get",
						cache: false,
						async: false
					}
				},
				password: {
					required: true,
					minlength: ${setting.security.passwordMinLength},
					maxlength: ${setting.security.passwordMaxLength},
					pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z_]+$/,
				},
				captcha: "required",
				recommemder:{
					pattern: /^1[3,4,5,7,8]\d{9}$/,
				}, 
			}, 
			messages: {
				mobile: {
					required: "请输入您的手机号码",
					pattern: "请输入正确的手机号码",
					remote: "手机号码已存在"
				},
				password: {
					required: "请输入${setting.security.passwordMinLength}-${setting.security.passwordMaxLength}位密码",
					minlength: "请输入${setting.security.passwordMinLength}-${setting.security.passwordMaxLength}位密码",
					maxlength: "请输入${setting.security.passwordMinLength}-${setting.security.passwordMaxLength}位密码",
					pattern: "密码必须包含字母、数字"
				},
				captcha: {
					required: "请输入验证码",
				},
				recommemder:{
					pattern: "请输入正确的手机号码",
				},
			},
			errorPlacement: function(error, element) {
				element.closest("li").find(".note").text(error.text());
			},
			unhighlight: function(element) {
				$(element).closest("li").find(".note").text("");
			},
			submitHandler: function(form) {
				$submit.prop("disabled", true);
	
				$.ajax({
					url: "${base}/api/key",
					type: "get",
					dataType: "json",
					cache: false,
					success: function(message) {
						data = message.content;
						rsaKey.setPublic(b64tohex(data.modulus), b64tohex(data.exponent));
						[#-- AJAX注册 --]
						$.ajax({
							url: "${base}/api/cpas/customer/register",
							data: {
								mobile: $mobile.val(),
								password: hex2b64(rsaKey.encrypt($password.val())),
								mobileCaptcha: $captcha.val(),
								recommemder:$("#recommemder").val(),
								source:"${source}",
								code:"${code}"
							},
							type: "post",
							dataType: "json",
							cache: false,
							beforeSend: function(request, settings) {
								//request.setRequestHeader("token", getCookie("token"));
								//$submit.val(" 注 册 中 ... ");
							},
							success: function(message) {
								if (message.type == "success") {
									g_url="${base}/cpas/download";
									$("#rstImg").html('<img src="${base}/resources/wap/cpas/images/success-icon.png" width="60" alt="" />');
									$("#rstMsg").text("恭喜您，注册成功！");
									$.colorbox({
										href:"#result", 
										inline: true, 
										overlayClose:true, 
										width:"60%",
										height:"175px",
									});
									
								} else {
									g_url="";
									$submit.prop("disabled", false);
									$("#rstImg").html('<img src="${base}/resources/wap/cpas/images/fail-icon.png" width="60" alt="" />');
									$("#rstMsg").text(message.content);
									$.colorbox({
										href:"#result", 
										inline: true, 
										overlayClose:true, 
										width:"60%",
										height:"175px",
									});
													
								}
							},
							error: function() {
								g_url="";
								$submit.val(" 注 册 失 败 ");
								$("#rstImg").html('<img src="${base}/resources/wap/cpas/images/fail-icon.png" width="60" alt="" />');
								$("#rstMsg").text("注册失败，请刷新页面重试");
								$.colorbox({
									href:"#result", 
									inline: true, 
									overlayClose:true, 
									width:"60%",
									height:"175px",
								});
							}
						});
					}
				});
				return;
			}
		});
				
		[#-- 发送验证码 --]
		$captchaButton.click(function() {
			$captchaButton.prop("disabled", true);
		
			[#-- 验证手机号码 --]	
			if(!$validate.element($mobile)) {
				$captchaButton.prop("disabled", false);
				return false;
			}
			$.ajax({
				url: "${base}/api/key",
				type: "get",
				dataType: "json",
				cache: false,
				success: function(message) {
					data = message.content;
					rsaKey.setPublic(b64tohex(data.modulus), b64tohex(data.exponent));
					[#-- AJAX申请验证码 --]	
					$.ajax({
						url: "${base}/api/customer/register/send-texting",
						data: {
							mobile: hex2b64(rsaKey.encrypt($mobile.val()+"^!"))
						},
						type: "post",
						dataType: "json",
						cache: false,
						success: function(message) {				
							if(message.type == "success") {
								$captcha.closest("li").find(".note").text("");
								$disableButton($captchaButton, ${setting.security.tokenRetryTime});
							} else {
								$captcha.closest("li").find(".note").text(message.content);
								$captchaButton.prop("disabled", false);
							}
						}
					});
				}
			});
					
		});
	})
</script>
<script type="text/javascript">
	var u = navigator.userAgent;
	var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
	var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
	if(isiOS){
		$("#download").attr("href", "${ios}");
	}else{
		$("#download").attr("href", "${android}");
	}
</script>
[/#if]

<script>
$(function(){
	$(".close").click(function(){
		$(".footer").hide(200);
	});
});

function rsb(){
	$("#result").colorbox.close();
	if("" != g_url){
		location.href = g_url;
	}
}
</script>
</body>
</html>
