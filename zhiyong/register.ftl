[#-- 索引URL --]
[#assign wapIndexUrl = base + "/resources/wap" /]
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
<title>方巨金融-注册</title>
<link href="${wapIndexUrl}/css/base.css" rel="stylesheet" type="text/css" />
<link href="${wapIndexUrl}/css/login.css" rel="stylesheet" type="text/css" />
</head>

<body class="loginpage">
<section>
	<!--页头-->
	<header class="header">
    	<a href="javascript:history.back(-1);"><div class="icon3"></div></a>
		<div class="title">注册</div>
	</header>
	<!--页头结束-->
    
	<!--注册-->
	<div class="content">
		<form action="#" method="post" id="registerForm" class="form" style="background:none;">
			<ul>
				<li>
					<div class="input"><input type="text" value="" id="mobile" name="mobile" class="input-text" placeholder="请输入您的手机号码" /></div>
					<div class="note clear"></div>
				</li>
				<li>
					<div class="input"><input type="password" value="" id="password" name="password" class="input-password" placeholder="请输入密码" /></div>
					<div class="note clear"></div>
				</li>
				<li>
					<div class="input"><input type="password" value="" id="rePassword" name="rePassword" class="input-password" placeholder="请再次输入密码" /></div>
					<div class="note clear"></div>
				</li>
				<li>
					<div class="input">
						<div class="pull-left"><input type="text" value="" id="captcha" name="captcha" class="input-yzm" placeholder="请输入验证码" /></div>
						<div class="pull-right"><input type="button"id="captchaButton" value="获取验证码" disableClassName="active" disablePromptValueSuffix="后重发" class="yzm-btn" /></div>
				    </div>
					<div class="note clear"></div>
				</li>
			</ul>
			<div class="btn">
				<input type="submit" value="完成注册"/>
				<div id="flashMessage" class="clear color-red note"></div>
			</div>
			<div class="link">
				<p>点击“完成注册”按钮，即表示您同意</p>
				<p><a href="javascript:window.location.href='${base}/wap/login/agreement';" class="color-red">《XXX用户注册协议》</a></p>
				<div class="bottom">已有平台账号？<a href="javascript:window.location.href='${base}/wap/login';" class="color-red">请点击登录</a></div>
			</div>
		</form>
	</div>
</section>
<script src="${wapIndexUrl}/js/jquery-1.11.3.min.js"></script>
[#--公共JS--]
<script src="${base}/resources/wap/js/common.js?version=${setting.basic.siteVersion}"></script>
[#-- RSA加密 --]
<script src="${base}/resources/lib/tools/rsa/jsbn.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/prng4.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/rng.min.js"></script>
<script src="${base}/resources/lib/tools/rsa/rsa.min.js"></script>
<script src="${base}/resources/lib/tools/base/base64.min.js"></script>
[#-- validate 验证器 --]
<script src="${base}/resources/lib/validate/jquery.validate.min.js"></script>
<script src="${base}/resources/lib/validate/jquery.validate.method.min.js"></script>
[#-- 弹出层 --]
<script src="${base}/resources/js/jquery.colorbox.js?version=${setting.basic.siteVersion}"></script>
[#-- 启用验证码 --]
[#assign enabledCaptcha = (setting.security.captchaScopes?? && setting.security.captchaScopes?seq_contains("findPassword")) /]
<script>
	$(".content").css("height",$(window).height()-50);
	$(".form").css("height",$(window).height()-70);
	var modulus = "${modulus}", exponent = "${exponent}";
	$(function() {
		var $registerForm = $("#registerForm"),$captchaButton = $("#captchaButton"),$mobile=$("#mobile"),$flashMessage = $("#flashMessage");
		$submit = $registerForm.find(":submit"),$password = $("#password"),$rePassword = $("#rePassword"),$captcha = $("#captcha"),rsaKey = new RSAKey();
		rsaKey.setPublic(b64tohex(modulus), b64tohex(exponent));
		[#-- 表单验证 --]
		var $validate = $registerForm.validate({
			rules: {
				mobile: {
					required: true,
					pattern: /^1[3,4,5,7,8]\d{9}$/,
					remote: {
						url: "${base}/api/customer/mobile",
						type: "get",
						cache: false
					}
				},
				password: {
					required: true,
					minlength: ${setting.security.passwordMinLength},
					maxlength: ${setting.security.passwordMaxLength},
					pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z_]+$/,
				},
				rePassword: {
					required: true,
					equalTo: "#password"
				},
				captcha: "required", 
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
				rePassword: {
					required: "请输入确认密码",
					equalTo: "两次密码输入不一致"
				},
				captcha: {
					required: "请输入验证码",
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
	
				[#-- AJAX注册 --]
				$.ajax({
					url: "${base}/api/customer/register",
					data: {
						mobile: $mobile.val(),
						password: hex2b64(rsaKey.encrypt($password.val())),
						mobileCaptcha: $captcha.val()
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
							window.location.href ="${base}/wap/register/success?discountTickets="+message.content.discountTickets;
						} else {
							$flashMessage.text(message.content);
							$submit.prop("disabled", false);
						}
					},
					error: function() {
						$flashMessage.text("注册失败，请刷新页面重试");
						$submit.val(" 注 册 失 败 ");
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
			
			[#-- AJAX申请验证码 --]	
			$.ajax({
				url: "${base}/api/customer/register/send-texting",
				data: {
					mobile: $mobile.val()
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
			
		});
	})
</script>
<script>
	$(".loginpage").css("height",$(window).height());
</script>
</body>
</html>
