package cn.xt.sms.entity;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;

import java.util.Date;

/**
 * 操作日志记录 oper_log
 * 
 * @author ruoyi
 */
@Data
public class OperLog
{
    private static final long serialVersionUID = 1L;
    /** 日志主键 */
    private Integer operId;
    /** 模块标题 */
    private String title;
    /** 功能请求 */
    private String action;
    /** 请求方法 */
    private String method;
    /** 来源渠道 */
    private String channel;
    /** 操作员名称 */
    private String loginName;
    /** 请求url */
    private String operUrl;
    /** 操作地址 */
    private String operIp;
    /** 请求参数 */
    private String operParam;
    /** 状态0正常 1异常 */
    private int status;
    /** 错误消息 */
    private String errorMsg;
    /** 操作时间 */
    @JSONField(format = "yyyy-MM-dd hh:mm:ss")
    private Date operTime;

}
