package com.gaia3d.controller;

import java.security.spec.AlgorithmParameterSpec;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Hex;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import com.gaia3d.domain.CacheManager;
import com.gaia3d.domain.Policy;
import com.gaia3d.domain.SessionKey;
import com.gaia3d.domain.UserGroupRole;
import com.gaia3d.domain.UserInfo;
import com.gaia3d.domain.UserSession;
import com.gaia3d.helper.GroupRoleHelper;
import com.gaia3d.helper.SessionUserHelper;
import com.gaia3d.listener.Gaia3dHttpSessionBindingListener;
import com.gaia3d.security.Crypt;
import com.gaia3d.service.LoginService;
import com.gaia3d.service.RoleService;
import com.gaia3d.service.UserService;
import com.gaia3d.util.WebUtil;
import com.gaia3d.validator.LoginValidator;

import lombok.extern.slf4j.Slf4j;
import net.iharder.Base64;

/**
 * 로그인 처리
 *
 * @author jeongdae
 */
@Slf4j
@Controller
@RequestMapping("/login/")
public class LoginController {

    @Autowired
    private LocaleResolver localeResolver;
    @Resource(name="loginValidator")
    private LoginValidator loginValidator;
    @Autowired
    private LoginService loginService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private UserService userService;

    /**
    * 로그인 페이지
    * @param request
    * @param model
    * @return
    */
    @GetMapping("/login.do")
    public String login(HttpServletRequest request, Model model) {
        Policy policy = CacheManager.getPolicy();
        log.info("@@ policy = {}", policy);

        long nowTime = System.nanoTime();
        String TOKEN_AES_KEY = (String.valueOf(nowTime) + "0000000000").substring(0, 16);
        request.getSession().setAttribute(SessionKey.SESSION_TOKEN_AES_KEY.name() , TOKEN_AES_KEY);
        log.info("@@ SESSION_TOKEN_AES_KEY = {}", TOKEN_AES_KEY);

        UserInfo loginForm = new UserInfo();
        model.addAttribute("loginForm", loginForm);
        model.addAttribute("policy", policy);
        model.addAttribute("EncryptionKey", TOKEN_AES_KEY + "u/Gu5posvwDsXUnV5Zaq4g==" + TOKEN_AES_KEY);
        model.addAttribute("EncryptionIv", TOKEN_AES_KEY + "5D9r9ZVzEYYgha93/aUK2w==" + TOKEN_AES_KEY);
        model.addAttribute(SessionKey.TOKEN_AES_KEY.name(), TOKEN_AES_KEY);

        return "/login/login";
    }

    /**
    * 로그인 처리
    * @param locale
    * @param model
    * @return
    */
    @PostMapping(value = "process-login.do")
    public String processLogin(HttpServletRequest request, @ModelAttribute("loginForm") UserInfo loginForm, BindingResult bindingResult, Model model) {

        Policy policy = CacheManager.getPolicy();
        String SESSION_TOKEN_AES_KEY = (String)request.getSession().getAttribute(SessionKey.SESSION_TOKEN_AES_KEY.name());
        try {

            SecretKey key = new SecretKeySpec(Base64.decode("u/Gu5posvwDsXUnV5Zaq4g=="), "AES");
            AlgorithmParameterSpec iv = new IvParameterSpec(Base64.decode("5D9r9ZVzEYYgha93/aUK2w=="));
            byte[] decodeBase64 = Base64.decode(loginForm.getPassword());
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, key, iv);

            String afterDecrypt = new String(cipher.doFinal(decodeBase64), "UTF-8");
            byte[] bytes = Hex.decodeHex(afterDecrypt.toCharArray());
            String plainTextPassword = new String(bytes, "UTF-8");

            //AESCipher aESCipher = new AESCipher(SESSION_TOKEN_AES_KEY);
            log.info("@@ SESSION_TOKEN_AES_KEY = {}", SESSION_TOKEN_AES_KEY);
            log.info("@@ password = {}", loginForm.getPassword());
//			log.info("@@ url decode = {}", URLDecoder.decode(loginForm.getPassword(), "utf-8"));
//			loginForm.setPassword(aESCipher.decrypt(URLDecoder.decode(loginForm.getPassword(), "utf-8")));
            loginForm.setPassword(plainTextPassword);

        } catch(Exception e) {
            e.printStackTrace();
            bindingResult.rejectValue("password", "login.password.decrypt.exception", e.getMessage());
        }

        this.loginValidator.validate(loginForm, bindingResult);
        if(bindingResult.hasErrors()) {
            List<ObjectError> errorList = bindingResult.getAllErrors();
            for(ObjectError error : errorList) {
                log.info("************************* error message = {}", error.getDefaultMessage());
            }

            log.info("@@ validation error!");
            loginForm.setPassword(null);
            loginForm.setError_code("field.required");
            model.addAttribute("loginForm", loginForm);
            model.addAttribute("policy", policy);
            model.addAttribute("TOKEN_AES_KEY", SESSION_TOKEN_AES_KEY);
            return "/login/login";
        }

        loginForm.setPassword_change_term(policy.getPassword_change_term());
        loginForm.setUser_last_login_lock(policy.getUser_last_login_lock());
        UserSession userSession = loginService.getUserSession(loginForm);
        log.info("@@ userSession = {} ", userSession);

        String errorCode = validateUserInfo(request, false, policy, loginForm, userSession);
        if(errorCode != null) {
            if("usersession.password.invalid".equals(errorCode)) {
                UserInfo userInfo = new UserInfo();
                userInfo.setUser_id(userSession.getUser_id());
                userInfo.setFail_login_count(userSession.getFail_login_count() + 1);
                // 실패 횟수가 운영 정책의 횟수와 일치할 경우 잠금(비밀번호 실패횟수 초과)
                if(userInfo.getFail_login_count() >= policy.getUser_fail_login_count()) {
                    log.error("@@ 비밀번호 실패 횟수 초과에 의해 잠김 처리됨");
                    userInfo.setStatus(UserInfo.STATUS_FAIL_LOGIN_COUNT_OVER);
                    loginForm.setStatus(UserInfo.STATUS_FAIL_LOGIN_COUNT_OVER);
                }
                userService.updateUserFailLoginCount(userInfo);
                bindingResult.rejectValue("user_id", "usersession.password.invalid");
            } else if("usersession.lastlogin.invalid".equals(errorCode)) {
                UserInfo userInfo = new UserInfo();
                userInfo.setUser_id(userSession.getUser_id());
                userInfo.setStatus(UserInfo.STATUS_SLEEP);
                userService.updateUserStatus(userInfo);
                bindingResult.rejectValue("user_id", "usersession.lastlogin.invalid");
            } else {
                bindingResult.rejectValue("user_id", errorCode);
            }

            log.error("@@ errorCode = {} ", errorCode);
            loginForm.setError_code(errorCode);
            loginForm.setUser_id(null);
            loginForm.setPassword(null);
            model.addAttribute("loginForm", loginForm);
            model.addAttribute("policy", policy);
            model.addAttribute("TOKEN_AES_KEY", SessionKey.TOKEN_AES_KEY.name());

            return "/login/login";
        }

        // 사용자 정보를 갱신
        userSession.setFail_login_count(0);
        loginService.updateLoginUserSession(userSession);

        // TODO 고민을 하자. 로그인 시점에 토큰을 발행해서 사용하고.... 비밀번호와 SALT는 초기화 해서 세션에 저장할지
//		userSession.setPassword(null);
//		userSession.setSalt(null);

        // 암호화를 위한 키 삭제
        request.getSession().removeAttribute(SessionKey.SESSION_TOKEN_AES_KEY.name());

        userSession.setLogin_ip(WebUtil.getClientIp(request));
        Gaia3dHttpSessionBindingListener sessionListener = new Gaia3dHttpSessionBindingListener();
        request.getSession().setAttribute(UserSession.KEY, userSession);
        request.getSession().setAttribute(userSession.getUser_id(), sessionListener);
        if(Policy.Y.equals(policy.getSecurity_session_timeout_yn())) {
            // 세션 타임 아웃 시간을 초 단위로 변경해서 설정
            request.getSession().setMaxInactiveInterval(Integer.valueOf(policy.getSecurity_session_timeout()).intValue() * 60);
        }

        // 패스워드 변경 기간이 오버 되었거나 , 6:임시 비밀번호(비밀번호 찾기, 관리자 설정에 의한 임시 비밀번호 발급 시)
        if(userSession.getPassword_change_term_over() || UserInfo.STATUS_TEMP_PASSWORD.equals(userSession.getStatus())){
            return "redirect:/user/modify-password.do";
        }

        return "redirect:/main/index.do";
    }

    /**
    * 사용자 정보 유효성을 체크하여 에러 코드를 리턴
    * @param request
    * @param policy
    * @param loginForm
    * @param userSession
    * @return
    */
    private String validateUserInfo(HttpServletRequest request, boolean isSSO, Policy policy, UserInfo loginForm, UserSession userSession) {

        // 사용자 정보가 존재하지 않을 경우
        if(userSession == null) {
            return "user.session.empty";
        }

        // Single Sign-On의 경우 비밀번호 체크 하지 않음
        if(!isSSO) {
            // 비밀번호 불일치
            boolean isPasswordEquals = false;
            try {
                ShaPasswordEncoder shaPasswordEncoder = new ShaPasswordEncoder(512);
                shaPasswordEncoder.setIterations(1000);
                String encryptPassword = shaPasswordEncoder.encodePassword(loginForm.getPassword(), userSession.getSalt()) ;
                log.info("@@ dbpassword = {}, encryptPassword = {}", userSession.getPassword(), encryptPassword);
                if(userSession.getPassword().equals(encryptPassword)) {
                    isPasswordEquals = true;
                }
            } catch(Exception e) {
                log.error("@@ 로그인 체크 암호화 처리 모듈에서 오류가 발생 했습니다. ");
                e.printStackTrace();
            }
            if(!isPasswordEquals) {
                return "usersession.password.invalid";
            }
        }

        // 회원 상태 체크
        if(!UserInfo.STATUS_USE.equals(userSession.getStatus()) && !UserInfo.STATUS_TEMP_PASSWORD.equals(userSession.getStatus())) {
            // 0:사용중, 1:사용중지(관리자), 2:잠금(비밀번호 실패횟수 초과), 3:휴면(로그인 기간), 4:만료(사용기간 종료), 5:삭제(화면 비표시)
            loginForm.setStatus(userSession.getStatus());
            return "usersession.status.invalid";
        }

        // 로그인 실패 횟수
        if(userSession.getFail_login_count().intValue() >= policy.getUser_fail_login_count()) {
            loginForm.setFail_login_count(userSession.getFail_login_count());
            return "usersession.faillogincount.invalid";
        }

        // 마지막 접속일(접속 정책이 3개월 미접속인 경우 접속 금지의 경우)
        if(userSession.getUser_last_login_lock_over()) {
            loginForm.setLast_login_date(userSession.getLast_login_date());
            loginForm.setUser_last_login_lock(policy.getUser_last_login_lock());
            return "usersession.lastlogin.invalid";
        }

        // 초기 세팅시만 이 값을 N으로 세팅해서 사용자 Role 체크 하지 않음
        if(!UserSession.N.equals(userSession.getUser_role_check_yn())) {
            // 사용자 그룹 ROLE 확인
            UserGroupRole userGroupRole = new UserGroupRole();
            userGroupRole.setUser_id(userSession.getUser_id());
            if(!GroupRoleHelper.isUserGroupRoleValid(roleService.getListUserGroupRoleByUserId(userGroupRole), UserGroupRole.USER_ADMIN_LOGIN)) {
                return "usersession.role.invalid";
            }
        }

//		// 사용자 IP 체크
//		if(Policy.Y.equals(policy.getSecurity_user_ip_check_yn())) {
//			UserDevice userDevice = new UserDevice();
//			userDevice.setUser_id(userSession.getUser_id());
//			userDevice.setDevice_ip(WebUtil.getClientIp(request));
//			UserDevice dbUserDevice = userDeviceService.getUserDeviceByUserIp(userDevice);
//			if(dbUserDevice == null || dbUserDevice.getUser_device_id() == null || dbUserDevice.getUser_device_id().longValue() <= 0l) {
//				return "userdevice.ip.invalid";
//			}
//		}

        // TODO 사용기간이 종료 되었는지 확인할것

        // 중복 로그인 허용 하지 않을 경우, 동일 아이디로 생성된 세션이 존재할 경우 파기
        log.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ user_duplication_login_yn() = {}", policy.getUser_duplication_login_yn());
        if("N".equals(policy.getUser_duplication_login_yn())) {
            log.info("----------------- concurrent map = {}", SessionUserHelper.loginUsersMap);
            if(SessionUserHelper.isExistSession(userSession.getUser_id())) {
                log.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 중복 로그인 user_id = {}", userSession.getUser_id());
                SessionUserHelper.invalidateSession(userSession.getUser_id());
            }
        }

        return null;
    }

    /**
    * 언어 설정
    * @param model
    * @return
    */
    @GetMapping(value = "ajax-change-language.do")
    @ResponseBody
    public Map<String, Object> ajaxChangeLanguage(HttpServletRequest request, HttpServletResponse response, @RequestParam("lang") String lang, Model model) {
        Map<String, Object> map = new HashMap<>();
        String result = "success";
        try {
            log.info("@@ lang = {}", lang);
            if(Locale.KOREA.getLanguage().equals(lang)
                    || Locale.ENGLISH.getLanguage().equals(lang)
                    || Locale.JAPAN.getLanguage().equals(lang)) {
                request.getSession().setAttribute(SessionKey.LANG.name(), lang);
                Locale locale = new Locale(lang);
//				LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
//				localeResolver.setLocale(request, response, locale);
                localeResolver.setLocale(request, response, locale);
            }
        } catch(Exception e) {
            e.printStackTrace();
            result = "db.exception";
        }

        map.put("result", result);

        return map;
    }

    /**
    * 로그아웃 페이지
    * @param model
    * @return
    */
    @GetMapping(value = "logout.do")
    public String logout(HttpServletRequest request, Model model) {

        HttpSession session = request.getSession();
        UserSession userSession = (UserSession)session.getAttribute(UserSession.KEY);

        if(userSession == null) {
            return "redirect:/login/login.do";
        }

        session.removeAttribute(userSession.getUser_id());
        session.removeAttribute(UserSession.KEY);
        session.invalidate();

        return "redirect:/login/login.do";
    }

    /**
     * 비밀번호 찾기 페이지
     * @param model
     * @return
     */
     @GetMapping(value = "userid-check.do")
     public String findPassword(HttpServletRequest request) {
         return "/login/userid-check";
     }

     /**
      * 비밀번호 찾기 페이지
      * @param model
      * @return
      */
      @PostMapping(value = "find-password.do")
      public String useridCheck(HttpServletRequest request, @ModelAttribute("idCheckForm") UserInfo idCheckForm,  Model model) {
         String userId = idCheckForm.getUser_id();
         int count = userService.getDuplicationIdCount(userId);
         UserInfo userinfo = userService.getUser(userId);
         if(count == 0) {
             String errorCode = "login.id.check";
             idCheckForm.setError_code(errorCode);
             idCheckForm.setUser_id(null);
             model.addAttribute("idCheckForm", idCheckForm);
             return "/login/userid-check";
         }
         else {
             String checkEmail = userinfo.getViewEmail();
             String checkPhone = userinfo.getViewMobilePhone();
             if(checkEmail.equals("") || checkPhone.equals("")) {
                 String errorCode = "login.information.check";
                 idCheckForm.setError_code(errorCode);
                 idCheckForm.setUser_id(null);
                 model.addAttribute("idCheckForm", idCheckForm);
                     return "/login/userid-check";
             }
             String []emailSplit = checkEmail.split("@");
             checkEmail = emailSplit[0].substring(0, emailSplit[0].length()-3);
             checkEmail += "***" + "@" + emailSplit[1];
             checkPhone = checkPhone.replaceAll("-", "");
             checkPhone = checkPhone.substring(0, checkPhone.length()-4);
             checkPhone += "****";
             userinfo.setEmail(checkEmail);
             userinfo.setMobile_phone(checkPhone);
             model.addAttribute("userinfo", userinfo);
         }
         return "/login/find-password";
      }

      /**
       * 비밀번호 초기화해서 이메일 발송
       * @param model
       * @return
       */
       @PostMapping(value = "send-passwordEmail.do")
       @ResponseBody
       public Map<String, Object> sendPasswordEmail(HttpServletRequest request, @ModelAttribute("informationCheckForm") UserInfo checkForm, Model model) {
        Map<String, Object> map = new HashMap<>();
        String message ="";
        checkForm.setMobile_phone(checkForm.getMobile_phone1()+"-"+checkForm.getMobile_phone2()+"-"+checkForm.getMobile_phone3());
        checkForm.setMobile_phone(Crypt.encrypt(checkForm.getMobile_phone()));
        checkForm.setEmail(Crypt.encrypt(checkForm.getEmail()));
        int count = userService.getUserInformationCheck(checkForm);
        if(count > 0) {
            message="login.information.success";
        }
        else {
            message="login.information.fail";
        }
        map.put("result", message);
        return map;
       }

}
