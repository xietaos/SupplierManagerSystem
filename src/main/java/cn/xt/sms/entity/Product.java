package cn.xt.sms.entity;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;

import java.util.Date;

/**
 * 产品信息类
 * @author xietao.x@qq.com
 */
@Data
public class Product {

    private Integer id;//材料ID
    private String no;//产品编号
    private String name;//产品名称
    private ProductBrand brandId;//品牌
    private String size;//规格型号
    private String technicalParam;//技术参数
    private String unit;//单位
    private Float unitprice;//单位价格
    private String comment;//备注
    private Supplier supplierId;//供应商
    private ProductGroup groupId;//分组

    public Product() {
    }

}
