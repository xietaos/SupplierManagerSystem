jQuery(function($) {

    /*全局常用参数与对象*/
    var keywords = $("#keywords");
    var currentPage = $("#currentPage");
    var pageSize = $("#pageSize");

    var defaultParams = {};
    initParam();

    /*参数初始化方法*/
    function initParam() {

        defaultParams.supplierId = $id; //供应商ID
        defaultParams.currentPage = 1; //当前页参数
        defaultParams.pageSize = 10; //每页条数参数
        defaultParams.keywords = null; //关键字参数

        keywords.val(defaultParams.keywords);
        currentPage.val(defaultParams.currentPage);
        pageSize.val(defaultParams.pageSize);

    }

    var table = new Table({
        params: defaultParams,
        table: $("#file-table"),
        dataUrl: $ctx + "/document/getDocumentList",
        render: render_file,
        buttons: "<div class='col-sm-3 col-xs-12'>" +
        "    <shiro:hasAnyPermission name='admin,deleteSupplierDocument'>" +
        "        <button class='btn btn-danger btn-sm btn-white btn-round' id='allDelete' style='height: 34px;'>" +
        "            <i class='ace-icon fa fa-trash-o'></i> 删除选中项" +
        "        </button>" +
        "    </shiro:hasAnyPermission>" +
        "    <button class='btn btn-warning btn-sm btn-white btn-round' id='refursh' style='height: 34px;'>" +
        "        <i class='ace-icon fa fa-bolt'></i> 刷新" +
        "    </button>" +
        "    <shiro:hasAnyPermission name='admin,insertSupplierDocument'>" +
        "        <button class='btn btn-success btn-sm btn-white btn-round' id='insert' style='height: 34px;'>" +
        "            <i class='ace-icon fa fa-plus'></i> 新增" +
        "        </button>" +
        "    </shiro:hasAnyPermission>" +
        "</div>"
    });

    //初始化表格的复选框逻辑功能
    initTableCheckbox("#file-table");


    /*绑定按名称排序功能*/
    $("[class=sort-name]").click(function() {
        // 未激活排序状态 -> 降序排序状态 MySQL默认升序排列
        if (!$(this).hasClass("active")) {
            $(this).attr("class", "sort-name active active-down");
            defaultParams.sortField = "name";
            defaultParams.sortMode = "desc";
        }
        else {
            // 降序 -> 升序
            if ($(this).hasClass("active-down")) {
                $(this).attr("class", "sort-name active active-up");
                defaultParams.sortMode = null;
            }
            // 升序 -> 取消激活
            else {
                $(this).removeClass("active-up").addClass("active-down");
                $(this).attr("class", "sort-name");
                // 恢复默认
                defaultParams.sortField = null;
            }
        }
        table.load();
    });


    /*刷新*/
    $("#refursh").click(function () {
        initParam();
        table.load();
    });

    /*删除选中行*/
    $("#allDelete").click(function () {
        if ($("#file-table > tbody > tr > td input[type=checkbox]:checked").length < 1) {
            $.modalMsg("请选中要删除的数据!", "success");
            return;
        }
        var ids = "";
        var idLength = 0;
        $("#file-table > tbody > tr > td input[type='checkbox']").each(function (index, element) {
            if (element.checked) {
                ids += element.getAttribute("data-id") + ",";
                idLength++;
            }
        });
        $.modalConfirm("你确定要删除选中的" + idLength + "行数据吗?", function (isOk) {
            if (isOk) {
                $.post($ctx + "/document/deleteDocument", {ids: ids}, function (data) {
                    var data = JSON.parse(data);
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

    function render_file(data) {

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

                // 设置搜索时匹配部分高亮显示 针对 name
                if (defaultParams.keywords) {
                    var rule = RegExp(defaultParams.keywords + "+", "g");
                    item.name = item.name.replace(rule, "<span style='color: red;'>" + defaultParams.keywords + "</span>");
                }

                if (!item.appendixName)
                    item.appendixName = "<span style='color: #EE8944'>无</span>";

                // 对商品名称添加事件链接
                // item.name = convert_href_html(item.name, false, "javascript:void(0);", 'table-a');

                content += "<tr>" +
                    "<td>" + startNo++ + "</td>" +
                    "<td class='center trbox'> <label class='pos-rel'> <input type='checkbox' class='ace' data-id='" + item.id + "' /> <span class='lbl'></span> </label> </td>" +
                    "<td>" + item.name + "</td>" +
                    "<td>" + item.type.name + "</td>" +
                    "<td></td>" +
                    "<td>" + item.appendixName + "</td>" +
                    "<td>" +
                        "<shiro:hasAnyPermission name='admin,deleteFile'>" +
                        "    <button class='btn btn-xs btn-round btn-danger deleteFile' data-id='" + item.id + "'> <i class='ace-icon fa fa-trash-o bigger-120'></i>删除 </button>" +
                        "</shiro:hasAnyPermission>" +
                    "</td>" +
                "</tr>";
            });
        } else {
            content += "<tr><td colspan='100'><div class='alert alert-warning' style='padding: 5px;margin-bottom: 0;text-align: center;'>没有信息</div></td></tr>";
        }
        $("#file-table > tbody").html(content);

        // $("#file-table .product-name").each(function (index, item) {
        //     if (data.rows[index]) {
        //         $(this).click(function () {
        //             showProductDetail(data.rows[index]);
        //         });
        //     }
        // });

        // $("#file-table .technical-param > a").popover({html: true});

    }

    /*删除信息操作*/
    //单行删除
    $("#file-table").delegate(".deleteFile", "click", function () {
        var this_ = this;
        $.modalConfirm("你确定要删除这条数据吗?", function (isOk) {
            if (isOk) {
                var id = this_.getAttribute("data-id");
                $.post($ctx + "/document/deleteDocument", {ids: id}, function (data) {
                    var data = JSON.parse(data);
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

});