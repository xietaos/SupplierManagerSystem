<%@ page import="cn.xt.sms.constant.PrivilegeConstants" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: xietao
  Date: 2018/4/18
  Time: 14:15
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta charset="utf-8" />
    <title>查询商品信息 - 供应商管理系统</title>

    <meta name="description" content="with selectable elements and custom icons" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

    <!-- bootstrap & fontawesome -->
    <link rel="shortcut icon" href="${pageContent.request.contentPath}/statics/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/bootstrap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/components/font-awesome/css/font-awesome.min.css" />

    <!-- page specific plugin styles -->
    <link rel="stylesheet" href="${pageContent.request.contentPath}/statics/css/bootstrap-dialog.css" />
    <link rel="stylesheet" href="${pageContent.request.contentPath}/statics/components/chosen/chosen.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/components/dropzone/dist/dropzone.css" />

    <!-- text fonts -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace-fonts.css" />

    <!-- ace styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style" />

    <!--[if lte IE 9]>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace-part2.css" class="ace-main-stylesheet" />
    <![endif]-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace-skins.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace-rtl.css" />
    <style type="text/css">
        .page-header h1{ font-size: 18px; }
        #product-form-modal>.modal-dialog{width:800px;margin:30px auto;margin-top:30px}
        hr{border-style:dashed;margin:5px 0}
        .filter-box{margin:6px 20px}
        .filter-head button{color:#000;float:right;background-color:#FFF;border:1px solid #DDD}
        .filter-head button:hover{color:red;border:1px solid orange}
        .filter-head button:after{font-family:FontAwesome;font-size:14px;content:"\f106";padding:0;margin:0 8px 0 10px;position:relative;top:1px}
        .filter-head button.show:after{content:"\f107"}
        .filter-body{border:1px solid #e8e8e8;margin:6px -12px;padding:6px}
        .filter-body .group .group-head{line-height:30px;color:#999}
        .filter-body .group-lowest .group-head{line-height:30px;color:#999}
        .filter-body .group .group-body ul{line-height:24px;list-style:none;margin:0}
        .filter-body .group .group-body ul li{border:1px solid #fff;margin:0 10px;padding:2px;float:left}
        .filter-body .group .group-body ul li.active{border-color:orange}
        .filter-body .group .group-body ul li:hover{color:red}
        .filter-body .group .group-body ul li.active:hover{border-color:red}
        .filter-body .group .group-foot button{color:#000;background-color:#FFF;border:1px solid #DDD}
        .filter-body .group .group-foot button:hover{color:red}
        .filter-body .group .group-foot span:hover{color:red}
        .filter-body .group .group-foot span:after{font-family:FontAwesome;content:"\f107"}
        .filter-body .group .group-foot span.active:after{content:"\f106"}
        /*设置为0 隐藏自定义菜单*/
        /*隐藏溢出的元素*/
        /*自定义菜单相对与body元素进行定位*/
        #my-menu{width:0;z-index:2;background-color:#fff;height:75px;overflow:hidden;box-shadow:0 1px 1px #888,1px 0 1px #ccc;position:absolute}
        .my-menu{width:130px;height:25px;line-height:25px;padding:0 10px;cursor:pointer}
        .my-menu:hover{background-color:#0ff}

        .span-block { display: block; padding: 5px 10px; background: #B8C2B8; -webkit-border-radius: 3px;-moz-border-radius: 3px; border-radius: 3px; }
        .span-line { display: block; padding: 5px 10px; border-bottom: 1px solid orange; }
    </style>

    <!--[if lte IE 9]>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace-ie.css" />
    <![endif]-->

    <!-- inline styles related to this page -->

    <!-- ace settings handler -->
    <script src="${pageContext.request.contextPath}/statics/assets/js/ace-extra.js"></script>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]>
    <script src="${pageContext.request.contextPath}/statics/components/html5shiv/dist/html5shiv.min.js"></script>
    <script src="${pageContext.request.contextPath}/statics/components/respond/dest/respond.min.js"></script>
    <![endif]-->
</head>

<body class="no-skin">

<jsp:include page="${pageContext.request.contextPath}/common/head.jsp"/>

<!-- /section:basics/navbar.layout -->
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try{ace.settings.loadState('main-container')}catch(e){}
    </script>

    <% request.setAttribute("active","Product-Search"); %>
    <jsp:include page="${pageContext.request.contextPath}/common/menu.jsp"/>

    <!-- /section:basics/sidebar -->
    <div class="main-content">
        <div class="main-content-inner">

            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <!-- /section:settings.box -->
                <div class="page-header">
                    <h1>
                        商品信息管理
                        <small>
                            <i class="ace-icon fa fa-angle-double-right"></i>
                            商品信息查询
                        </small>
                        <div class="btn-group" style="float: right;">
                            <shiro:hasAnyPermission name="admin,product:insert">
                                <button class="btn btn-success btn-sm btn-round" id="import-excel-button" style="height: 34px; border-width: 1px; margin-right: 10px;">
                                    <i class="ace-icon fa fa-arrow-circle-o-down"></i> 导入Excel
                                </button>
                            </shiro:hasAnyPermission>
                            <shiro:hasAnyPermission name="admin,product:search">
                                <button class="btn btn-warning btn-sm btn-round" id="export-excel-button" style="height: 34px; border-width: 1px; margin-right: 10px;">
                                    <i class="ace-icon fa fa-arrow-circle-o-up"></i> 导出Excel
                                </button>
                            </shiro:hasAnyPermission>
                        </div>
                    </h1>

                </div><!-- /.page-header -->

                <div class="row">
                    <div class="col-xs-12">
                        <!-- PAGE CONTENT BEGINS -->

                        <!-- #section:plugins/fuelux.treeview -->
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="widget-box widget-color-blue2">
                                    <div class="widget-header">
                                        <h4 class="widget-title lighter smaller">商品信息汇总</h4>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-8">
                                            <div class="row">
                                                <div class="col-sm-2" style="border-right: 1px dashed orange;">
                                                    <ul id="product-group-tree"></ul>
                                                    <%--<button id="tree-search" class="btn btn-xs btn-success" style="margin-top: 6px;">
                                                        <i class="ace-icon fa fa-search">查询</i>
                                                    </button>--%>
                                                </div>
                                                <div class="col-sm-10">
                                                    <div class="row filter-box">
                                                        <div class="row filter-head">
                                                            <span class="label label-lg label-success arrowed-right">所有分类</span>
                                                            <button id="toggle-filter">收起筛选</button>
                                                        </div>
                                                        <div class="row filter-body groups">
                                                            <div class="row group" data-name="brandIds">
                                                                <div class="col-sm-1 col-xs-12 group-head">品牌：</div>
                                                                <div class="col-sm-10 col-xs-12 group-body">
                                                                    <ul id="brandIds">
                                                                    </ul>
                                                                </div>
                                                                <div class="col-sm-1 col-xs-12 group-foot">
                                                                    <button class="select-multi">多选</button>
                                                                </div>
                                                            </div>
                                                            <hr/>
                                                            <div class="row group-lowest">
                                                                <div class="col-sm-1 col-xs-12 group-head">综合筛选：</div>
                                                                <div class="col-sm-11 col-xs-12 group-body">
                                                                    <div class="row">
                                                                        <form class="form-search">
                                                                            <div class="col-sm-3">
                                                                                <div class="input-group input-group-sm">
                                                                                    <span class="input-group-addon">
                                                                                        品牌
                                                                                    </span>

                                                                                    <input type="text" class="form-control search-query" id="brand-input" placeholder="按品牌搜索" />
                                                                                    <span class="input-group-btn">
                                                                                        <button type="button" class="btn btn-purple btn-xs" id="brand-search">
                                                                                            <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                                                                            搜索
                                                                                        </button>
                                                                                    </span>
                                                                                </div>
                                                                            </div>

                                                                            <div class="col-sm-3">
                                                                                <div class="input-group input-group-sm">
                                                                                    <span class="input-group-addon">
                                                                                        供应商
                                                                                    </span>

                                                                                    <input type="text" class="form-control search-query" id="supplier-input" placeholder="按供应商搜索" />
                                                                                    <span class="input-group-btn">
                                                                                        <button type="button" class="btn btn-info btn-xs" id="supplier-search">
                                                                                            <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                                                                            搜索
                                                                                        </button>
                                                                                    </span>
                                                                                </div>
                                                                            </div>

                                                                            <div class="col-sm-4">
                                                                                <div class="input-group input-group-sm">
                                                                                    <span class="input-group-addon">
                                                                                        价格区间
                                                                                    </span>

                                                                                    <input type="text" class="form-control search-query number-box" id="price-min-input" placeholder="0.00" />
                                                                                    <span class="input-group-addon">
                                                                                        <i class="ace-icon fa fa-angle-double-right"></i>
                                                                                    </span>
                                                                                    <input type="text" class="form-control search-query number-box" id="price-max-input" placeholder="0.00" />
                                                                                    <span class="input-group-btn">
                                                                                        <button type="button" class="btn btn-pink btn-xs" id="price-interval-search">
                                                                                            <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                                                                            搜索
                                                                                        </button>
                                                                                    </span>
                                                                                </div>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    <hr style="margin-top: 8px; margin-bottom: 8px; height: 1px; width: 100%; border-top: 1px dashed orange;" />
                                                    <table id="product-table" class="table  table-bordered table-hover">
                                                        <thead>
                                                        <tr>
                                                            <th>序号</th>
                                                            <th class="center"> <label class="pos-rel"> <input type="checkbox" class="ace" /> <span class="lbl"></span> </label> </th>
                                                            <th>商品编号</th>
                                                            <th>商品名称</th>
                                                            <th>商品规格</th>
                                                            <th>品牌</th>
                                                            <th>技术参数</th>
                                                            <th>价格-单位</th>
                                                            <th>备注</th>
                                                            <th>供应商</th>
                                                            <th>所属分组</th>
                                                            <th>操作</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- /section:plugins/fuelux.treeview -->

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.page-content -->
        </div>
    </div><!-- /.main-content -->

    <jsp:include page="${pageContext.request.contextPath}/common/foot.jsp"/>

    <a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
        <i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
    </a>

    <%-- 右键菜单 --%>
    <div id="my-menu">
        <shiro:hasAnyPermission name="admin,product_group:insert">
            <div class="my-menu" id="insertChildNode">添加子节点</div>
        </shiro:hasAnyPermission>
        <shiro:hasAnyPermission name="admin,product_group:delete">
            <div class="my-menu" id="deleteNode">删除节点</div>
        </shiro:hasAnyPermission>
        <shiro:hasAnyPermission name="admin,product_group:update">
            <div class="my-menu" id="updateNode">修改节点</div>
        </shiro:hasAnyPermission>
    </div>

    <!-- 商品信息表单 -->
    <div class="modal fade" id="product-form-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info">
                    <h4 class="modal-title green">
                    </h4>
                </div>
                <div class="modal-body">
                    <jsp:include page="${pageContext.request.contextPath}/common/product-form.jsp"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-white" data-dismiss="modal">
                        取消
                    </button>
                    <button type="button" class="btn btn-warning btn-white" id="confirm">
                        确定
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- 商品分组信息表单 -->
    <div class="modal fade" id="product-group-form-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info">
                    <h4 class="modal-title green">
                    </h4>
                </div>
                <div class="modal-body">
                    <jsp:include page="${pageContext.request.contextPath}/common/product-group-form.jsp"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-white" data-dismiss="modal">
                        取消
                    </button>
                    <button type="button" class="btn btn-warning btn-white" id="confirm-two">
                        确定
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- Excel上传模态框 -->
    <jsp:include page="${pageContext.request.contextPath}/common/excel-upload-modal.jsp"/>

</div><!-- /.main-container -->

<!-- basic scripts -->

<!--[if !IE]> -->
<script src="${pageContext.request.contextPath}/statics/components/jquery/dist/jquery.min.js"></script>

<!-- <![endif]-->

<!--[if IE]>
<script src="${pageContext.request.contextPath}/statics/components/jquery.1x/dist/jquery.js"></script>
<![endif]-->
<script type="text/javascript">
    if('ontouchstart' in document.documentElement) document.write("<script src='${pageContext.request.contextPath}/statics/components/_mod/jquery.mobile.custom/jquery.mobile.custom.js'>"+"<"+"/script>");
</script>
<script src="${pageContext.request.contextPath}/statics/components/bootstrap/dist/js/bootstrap.min.js"></script>

<!-- ace scripts -->
<jsp:include page="${pageContext.request.contextPath}/common/ace-script.jsp"/>
<jsp:include page="${pageContext.request.contextPath}/common/time.jsp"/>

<!-- page specific plugin scripts -->
<script src="${pageContext.request.contextPath}/statics/assets/js/src/elements.treeview-modified-version.js"></script>
<script src="${pageContext.request.contextPath}/statics/components/_mod/fuelux/tree-modified-version.js"></script>
<script src="${pageContext.request.contextPath}/statics/components/fuelux/js/spinbox.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/bootstrap-dialog.js"></script>
<script src="${pageContext.request.contextPath}/statics/components/chosen/chosen.jquery.js"></script>
<script src="${pageContext.request.contextPath}/statics/components/dropzone/dist/dropzone.js"></script>

<script src="${pageContext.request.contextPath}/statics/js/table.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/common.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/project/product/product.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/layer/layer.min.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/ry-common.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/ry-ui.js"></script>

<script type="text/javascript">
    // TODO 目的：shiro权限控制页面显示
    //      问题：使用js对页面内容动态添加时，嵌套在字符串中的<shiro>无效
    //          如：$(body).append("<shiro:hasAnyPermission name='admin'>你好</shiro:hasAnyPermission>"); // 无效
    //      临时方法：把是否拥有权限通过变量来存储，在动态添加的时候是否通过判断变量来指定某个标签是否需要显示
    //          如：const hasAdmin = false; <shiro:hasAnyPermission name="admin">hasAdmin = true;</shiro:hasAnyPermission>
    //              $(body).append("你好".display(hasAdmin)); display 是自定义添加的原生方法，如果hasAdmin=true返回原字符串，否则返回空字符串
    //      缺点：耦合高
    var has_product_delete = false; <shiro:hasAnyPermission name="admin,product:delete">has_product_delete = true;</shiro:hasAnyPermission>
    var has_product_insert = false; <shiro:hasAnyPermission name="admin,product:insert">has_product_insert = true;</shiro:hasAnyPermission>
    var has_product_update = false; <shiro:hasAnyPermission name="admin,product:update">has_product_update = true;</shiro:hasAnyPermission>
</script>

<!-- inline scripts related to this page -->
<script type="text/javascript">
    const $ctx = "${pageContext.request.contextPath}";
    var $currentPage = "<%=request.getAttribute("currentPage")%>";
    var $pageSize = "<%=request.getAttribute("pageSize")%>";
</script>
<script src="${pageContext.request.contextPath}/common/excel-download-modal.js"></script>
<script src="${pageContext.request.contextPath}/statics/js/project/product/search_product.js"></script>

<!-- the following scripts are used in demo only for onpage help and you don't need them -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/statics/assets/css/ace.onpage-help.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/statics/docs/assets/js/themes/sunburst.css" />

<script type="text/javascript"> ace.vars['base'] = '..'; </script>
<script src="${pageContext.request.contextPath}/statics/assets/js/src/elements.onpage-help.js"></script>
<script src="${pageContext.request.contextPath}/statics/assets/js/src/ace.onpage-help.js"></script>
<script src="${pageContext.request.contextPath}/statics/docs/assets/js/rainbow.js"></script>
<script src="${pageContext.request.contextPath}/statics/docs/assets/js/language/generic.js"></script>
<script src="${pageContext.request.contextPath}/statics/docs/assets/js/language/html.js"></script>
<script src="${pageContext.request.contextPath}/statics/docs/assets/js/language/css.js"></script>
<script src="${pageContext.request.contextPath}/statics/docs/assets/js/language/javascript.js"></script>
</body>
</html>
