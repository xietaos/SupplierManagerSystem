package cn.xt.sms.entity;

import lombok.Data;

import java.sql.Blob;
import java.util.Date;

/**
 * @Auther: xietao
 * @Date: 2018/7/24
 * @Description: 供应商文档 实体层
 */
@Data
public class SupplierDocument {

    private Integer id; // 文档id
    private String name; // 文档名称
    private DocumentType type; // 文档类型
    private String description; // 文档描述
    private String appendixName; // 附件名称
    private byte[] appendix; // 附件
    private Integer supplierId; // 所属供应商的Id
    private String supplierName; // 所属供应商的Name
    private Date createTime; // 创建时间

}
