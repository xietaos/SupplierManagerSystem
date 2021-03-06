package cn.xt.sms.controller;

import cn.xt.sms.annotation.Log;
import cn.xt.sms.annotation.RestGetMapping;
import cn.xt.sms.annotation.RestPostMapping;
import cn.xt.sms.constant.CommonConstants;
import cn.xt.sms.constant.PrivilegeConstants;
import cn.xt.sms.response.DataResponse;
import cn.xt.sms.entity.Privilege;
import cn.xt.sms.entity.User;
import cn.xt.sms.service.IUserService;
import cn.xt.sms.util.MD5Util;
import cn.xt.sms.util.Render;
import lombok.extern.log4j.Log4j;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import sun.misc.BASE64Decoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.List;

/**
 * 用户权限模块控制层
 * @author xietao.x@qq.com
 * @date 2018/3/28
 */
@Log4j
@Controller
@RequestMapping("/user")
public class UserController {

    private final String privilege_prefix = PrivilegeConstants.USER;

    @Autowired
    private IUserService userService;

    /*转到查询用户信息页面*/
    @RequiresPermissions(value = {"admin", privilege_prefix + ":search"}, logical = Logical.OR)
    @RequestMapping("/toSearchUser")
    public String toSearchUser() {
        return "user/user_search";
    }

    /*查看个人信息*/
    @RequestMapping("/toProfile")
    public String toProfile(HttpSession session) {
        String username = ((User) session.getAttribute("user")).getUsername();
        session.setAttribute("user", userService.getUserByUsername(username));
        return "user/profile";
    }

    /*查看个人信息*/
    @RequestMapping("/toUpdatePassword")
    public String toUpdatePassword(HttpSession session) {
        return "user/update_password";
    }

    /*查询用户信息*/
    @RequiresPermissions(value = {"admin", privilege_prefix + ":search"}, logical = Logical.OR)
    @RestGetMapping("/search")
    public DataResponse<User> search(String keywords, Integer currentPage, Integer pageSize) {
        return userService.getUserList(keywords, currentPage, pageSize);
    }

    /*删除用户数据*/
    @Log(title = "用户权限管理", action = "删除用户")
    @RequiresPermissions(value = {"admin", privilege_prefix + ":delete"},logical = Logical.OR)
    @RestPostMapping("/delete")
    public String delete(Integer id) {
        return userService.deleteUser(id);
    }

    /*多行删除用户数据*/
    @Log(title = "用户权限管理", action = "批量删除用户")
    @RequiresPermissions(value = {"admin", privilege_prefix + ":delete"},logical = Logical.OR)
    @RestPostMapping("/multiDelete")
    public String multiDelete(String ids) {
        return userService.multiDeleteUser(ids);
    }

    /*查询所有权限信息*/
    @RequiresPermissions(value = {"admin", privilege_prefix + ":search"},logical = Logical.OR)
    @RestGetMapping("/getAllPrivilege")
    public List<Privilege> getPrivilege() {
        return userService.getPrivilege();
    }

    /*修改用户权限信息*/
    @Log(title = "用户权限管理", action = "修改用户权限")
    @RequiresPermissions(value = {"admin", privilege_prefix + ":update"},logical = Logical.OR)
    @RestPostMapping("/updateUserPrivilege")
    public String updateUserPrivilege(Integer id, String privilegeIds) {
        return userService.updateUserPrivilege(id, privilegeIds);
    }

    /*获取用户权限信息*/
    @RequiresPermissions(value = {"admin", privilege_prefix + ":search"},logical = Logical.OR)
    @RestGetMapping("/getUserPrivilege")
    public List<Integer> getUserPrivilege(Integer id) {
        return userService.getUserPrivilege(id);
    }

    /*新增用户信息*/
    @Log(title = "用户权限管理", action = "添加用户")
    @RequiresPermissions(value = {"admin", privilege_prefix + ":insert"},logical = Logical.OR)
    @RestPostMapping("/insertUser")
    public String insert(User user) {
        user.setPassword(MD5Util.EncoderByMd5("123456"));
        return userService.insertUser(user);
    }

    /*修改用户信息*/
    @RestPostMapping("/updateBasicUser")
    public String updateBasicUser(User user, HttpSession session) {
        user.setId(((User) session.getAttribute("user")).getId());
        return userService.updateUser(user);
    }

    /*修改密码*/
    @RestPostMapping("/updatePassword")
    public String updatePassword(HttpSession session, String password) {
        if (password != null && password != "") {
            String username = ((User) session.getAttribute("user")).getUsername();
            return userService.updatePassword(username, MD5Util.EncoderByMd5(password));
        }
        return "fail";
    }

    /*验证原密码*/
    @RestPostMapping("/validatePassword")
    public boolean validataPassword(HttpSession session, String password) {
        if (password != null && password != "") {
            String username = ((User) session.getAttribute("user")).getUsername();
            return userService.validatePassword(username, MD5Util.EncoderByMd5(password));
        }
        return false;
    }

    /*修改用户高级信息*/
    @Log(title = "用户权限管理", action = "修改用户状态")
    @RequiresPermissions(value = {"admin", privilege_prefix + ":update"},logical = Logical.OR)
    @RestPostMapping("/updateCoreUser")
    public String updateCoreUser(User user) {
        return userService. updateUserByAdmin(user);
    }

    @RequiresPermissions(value = {"admin", privilege_prefix + ":search"},logical = Logical.OR)
    @RestGetMapping("/findUserById")
    public User findUserById(Integer id) {
        return userService.findUserById(id);
    }

    @RestPostMapping("/uploadHeadImg")
    public boolean uploadHeadFile(String file, HttpSession session) {

        //对字节数组字符串进行Base64解码并生成图片
        if (file == null) //图像数据为空
            return false;
        BASE64Decoder decoder = new BASE64Decoder();
        try
        {
            //Base64解码
            byte[] b = decoder.decodeBuffer(file);
            for(int i=0;i<b.length;++i)
            {
                if(b[i]<0)
                {//调整异常数据
                    b[i]+=256;
                }
            }
            String path = session.getServletContext().getRealPath(CommonConstants.HEAD_IMG_URL);
            String fileName = ((User) session.getAttribute("user")).getId() + ".jpg";
            //生成jpeg图片
            File dir = new File(path);
            if (!dir.exists()) dir.mkdirs();
            log.info(Render.renderInfo(path + "\\" + fileName));
            OutputStream out = new FileOutputStream(path + "\\" +fileName);
            out.write(b);
            out.flush();
            out.close();

            //修改头像数据到数据库
            userService.updateHeadUrl(fileName, ((User) session.getAttribute("user")).getUsername());

            return true;
        }
        catch (Exception e)
        {
            return false;
        }
    }

    /*头像上传的方法图片文件，返回url*/
    private String upload(MultipartFile file,HttpServletRequest request) {
        if (file != null) {
            String path = request.getSession().getServletContext().getRealPath(CommonConstants.HEAD_IMG_URL);
            String fileName = file.getOriginalFilename();

            File dir = new File(path,fileName);
            if(!dir.exists()){
                dir.mkdirs();
            }
            //MultipartFile自带的解析方法
            try {
                file.transferTo(dir);
            } catch (IOException e) {
                /*输出错误日志：头像文件解析异常*/
                log.error("The avatar file parsed the exception.");
                return null;
            }
            String url = CommonConstants.HEAD_IMG_URL + fileName;
            return url;
        }

        return null;
    }

}
