jQuery(function($) {
    /*全局常用参数与对象*/
    var keywords = $("#keywords");
    var currentPage = $("#currentPage");
    var pageSize = $("#pageSize");

    var defaultParams = {};
    initParam();

    /*参数初始化方法*/
    function initParam() {

        defaultParams = {
            supplierId: $id,//供应商ID
            currentPage: 1, //当前页参数
            pageSize: 10, //每页条数参数
            keywords: null //关键字参数
        };
        keywords.val(defaultParams.keywords);
        currentPage.val(defaultParams.currentPage);
        pageSize.val(defaultParams.pageSize);
    }

    var table = new Table({
        params: defaultParams,
        table: $("#product-table"),
        dataUrl: $ctx + "/product/getProductList",
        render: render_product,
        buttons: "<div class='col-sm-3 col-xs-12'>" +
        (
            "<button class='btn btn-danger btn-sm btn-white btn-round' id='allDelete' style='height: 34px;'>" +
            "    <i class='ace-icon fa fa-trash-o'></i> 删除选中项" +
            "</button>"
        ).display(has_product_delete) +
            "<button class='btn btn-warning btn-sm btn-white btn-round' id='refursh' style='height: 34px;'>" +
            "    <i class='ace-icon fa fa-bolt'></i> 刷新" +
            "</button>" +
        (
            "<button class='btn btn-success btn-sm btn-white btn-round' id='insert' style='height: 34px;'>" +
            "    <i class='ace-icon fa fa-plus'></i> 新增" +
            "</button>"
        ).display(has_product_insert) +
        "</div>"
    });

    //初始化表格的复选框逻辑功能
    initTableCheckbox("#product-table");

    /*刷新*/
    $("#refursh").click(function () {
        initParam();
        table.load();
    });

    /*删除选中行*/
    $("#allDelete").click(function () {
        if ($("#product-table > tbody > tr > td input[type=checkbox]:checked").length < 1) {
            $.modalMsg("请选中要删除的数据!", "success");
            return;
        }
        var ids = "";
        var idLength = 0;
        $("#product-table > tbody > tr > td input[type='checkbox']").each(function (index, element) {
            if (element.checked) {
                ids += element.getAttribute("data-id") + ",";
                idLength++;
            }
        });
        $.modalConfirm("你确定要删除选中的" + idLength + "行数据吗?", function (isOk) {
            if (isOk) {
                $.post($ctx + "/product/multiDeleteProduct", {ids: ids}, function (data) {
                    if (data && data.code == 0) {
                        $.modalMsg("删除成功", "success");
                        table.load();
                    } else {
                        $.modalMsg("删除失败", "error");
                    }
                }, "text");
            }
        });
    });

    /*页面初始化时加载数据*/
    /*检索初始参数*/
    var currentPageParam = $currentPage;
    var pageSizeParam = $pageSize;
    if (currentPageParam != "null" && currentPageParam != "") {
        defaultParams.currentPage = currentPageParam;
        currentPage.val(currentPageParam);
    }
    if (pageSizeParam != "null" && pageSizeParam != "") {
        defaultParams.pageSize = pageSizeParam;
        pageSize.val(pageSizeParam);
    }
    table.load();

    function render_product(data) {

        var content = "";
        console.log(data);

        // 1. 检查页码
        table.pagination.maxCount.html(data.count);
        table.pagination.checkPageState();

        if (data.rows != null && data.rows.length > 0) {

            // 2. 计算编号 （当前页数 - 1） * 每页数量 + 1 == 当前第一条记录的编号
            var startNo = (Number($("#currentPage").val()) - 1) * Number($("#pageSize").val()) + 1;
            startNo == NaN ? 1 : startNo;

            /*拼接字符串*/
            $.each(data.rows, function (index, item) {

                item.simpleTechnicalParam = item.technicalParam ? item.technicalParam.length > 15 ? item.technicalParam.substring(0, 15) + "..." : item.technicalParam : "";
                item.unitprice = item.unitprice + "元 / " + item.unit;
                item.size = item.size ? item.size : "";
                item.brandName = item.brandId ? item.brandId.name : "";
                item.comment = item.comment ? item.comment : "";

                // 设置搜索时匹配部分高亮显示 针对 no name brand
                if (defaultParams.keywords) {
                    var rule = RegExp(defaultParams.keywords + "+", "g");
                    item.no = item.no.replace(rule, "<span style='color: red;'>" + defaultParams.keywords + "</span>");
                    item.name = item.name.replace(rule, "<span style='color: red;'>" + defaultParams.keywords + "</span>");
                    item.brandName = item.brandName.replace(rule, "<span style='color: red;'>" + defaultParams.keywords + "</span>");
                }

                // 对商品名称添加事件链接
                item.name = convert_href_html(item.name, false, "javascript:void(0);", 'table-a');

                content += "<tr>" +
                    "<td>" + startNo++ + "</td>" +
                    "<td class='center trbox'> <label class='pos-rel'> <input type='checkbox' class='ace' data-id='" + item.id + "' /> <span class='lbl'></span> </label> </td>" +
                    "<td>" + item.no + "</td>" +
                    "<td class='product-name'>" + item.name + "</td>" +
                    "<td>" + item.size + "</td>" +
                    "<td>" + item.brandName + "</td>" +
                    "<td class='technical-param'> <a href='javascript:void(0);' data-trigger='hover' data-placement='auto top' data-toggle='popover' data-content='" + item.technicalParam + "'>" +
                    item.simpleTechnicalParam + "</a> </td>" +
                    "<td>" + item.unitprice + "</td>" +
                    "<td>" + item.comment + "</td>" +
                    "<td>" + item.groupId.name + "</td>" +
                    "<td>" +
                    "<div class='btn-group'>" +
                    (
                        "<button class='btn btn-xs btn-round btn-info updateProduct' data-id='" + item.id + "'> <i class='ace-icon fa fa-pencil bigger-120'></i>修改 </button>"
                    ).display(has_product_update) +
                    (
                        "<button class='btn btn-xs btn-round btn-warning deleteProduct' data-id='" + item.id + "'> <i class='ace-icon fa fa-trash-o bigger-120'></i>删除 </button>"
                    ).display(has_product_delete) +
                    "</div>" +
                    "</td>" +
                    "</tr>";
            });
        } else {
            content += "<tr><td colspan='100'><div class='alert alert-warning' style='padding: 5px;margin-bottom: 0;text-align: center;'>没有信息</div></td></tr>";
        }
        $("#product-table > tbody").html(content);

        $("#product-table .product-name").each(function (index, item) {
            if (data.rows[index]) {
                $(this).click(function () {
                    showProductDetail(data.rows[index]);
                });
            }
        });

        $("#product-table .technical-param > a").popover({html: true});

    }

    /*删除信息操作*/
    //单行删除
    $("#product-table").delegate(".deleteProduct", "click", function () {
        var this_ = this;
        $.modalConfirm("你确定要删除这条数据吗?", function (isOk) {
            if (isOk) {
                var id = this_.getAttribute("data-id");
                $.post($ctx + "/product/deleteProduct", {id: id}, function (data) {
                    if (data && data.code == 0) {
                        $.modalMsg("删除成功", "success");
                        table.load();
                    } else {
                        $.modalMsg("删除失败", "error");
                    }
                }, "json");
            }
        });
    });

    /*关键字查询*/
    keywords.keypress(function (event) {
        if (event.keyCode == 13) {
            exec();
        }
    });

    keywords.next().click(function () {
        exec();
    });

    function exec() {
        defaultParams.keywords = keywords.val();
        table.load();
    }

    //新增
    $("#insert").click(function() {
        window.supplierId = defaultParams.supplierId;
        layer_showAuto("新增商品信息", $ctx + "/product/toInsertPage");
    });

    //修改
    $("#product-table").delegate(".updateProduct", "click", function() {
        layer_showAuto("修改商品信息", $ctx + "/product/toUpdatePage?id=" + this.getAttribute("data-id"));
    });

    /*绑定将placeholder属性转换成value属性的方法*/
    function bind_placeholder_to_value($el) {
        $el = $($el);
        $el.unbind("focus", "blur");
        $el.bind({
            "focus": function() {
                if (!$el.val()) $el.val($el.attr("placeholder"));
            },
            "blur": function() {
                if ($el.val() == $el.attr("placeholder")) $el.val("");
            }
        });
    }
});

function showProductDetail(item) {
    layer.open({
        area: ['600px', '500px'],
        fix: false,
        //不固定
        maxmin: true,
        shade: 0.4,
        title: "商品详情",
        content: "<div class='row overview'>" +
        "<div class='col-sm-12 item'> <dl> <dt>商品编号：</dt> <dd>" + item.no + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>商品名称：</dt> <dd>" + item.name + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>商品规格：</dt> <dd>" + item.size + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>品牌：</dt> <dd>" + item.brandName + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>技术参数：</dt> <dd>" + item.technicalParam + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>价格-单位：</dt> <dd>" + item.unitprice + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>所属供应商：</dt> <dd>" + item.supplierId.fullName + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>所属分组：</dt> <dd>" + item.groupId.name + "</dd> </dl> </div>" +
        "<div class='col-sm-12 item'> <dl> <dt>备注：</dt> <dd>" + item.comment + "</dd> </dl> </div>" +
        "</div>"/*,
        btn: ['修改','确定'],
        yes: function(index, layero) {
            console.log(layero);
        },
        btn2: function(index, layero) {
            console.log(layero);
        }*/
    });
}