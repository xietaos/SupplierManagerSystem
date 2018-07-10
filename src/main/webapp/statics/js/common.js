/**
 * Created by xietao on 2018/4/25.
 */

/*AllForm == 修改验证输入框样式
* param
*   $el: 要修改的document对象|jQuery对象*/
function convert_warning($el, title) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-warning");
    $el.next().attr("class", "ace-icon fa fa-info-circle").attr("title", title ? title:"必填项");
}
function convert_success($el, title) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-success");
    $el.next().attr("class", "ace-icon fa fa-check-circle").attr("title", title ? title:"通过验证");
}
function convert_error($el, title) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-error");
    $el.next().attr("class", "ace-icon fa fa-times").attr("title", title ? title:"名称已存在");
}
function convert_success_clear($el) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-success");
    $el.next().attr("class", "").attr("title", "");
}
function convert_success_only($el) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-success");
}
function convert_warning_only($el) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-warning");
}
function convert_error_only($el) {
    $el = $($el);
    $el.closest(".form-group").attr("class", "form-group has-error");
}

/*数字框校验*/
$("body").delegate(".number-box", "keyup", function() {
    this.value = this.value.replace(/[^\d]/g, "");
});

$("body").delegate(".min-box", "keyup", function() {
    var $this = $(this);
    var min_value = $this.attr("data-min-value");
    if (!min_value) min_value = $this.attr("placeholder");
    if (Number($this.val()) < min_value) {
        $this.val(min_value);
    }
});

$("body").delegate(".max-box", "keyup", function() {
    var $this = $(this);
    var max_value = $this.attr("data-max-value");
    if (!max_value) max_value = $this.attr("placeholder");
    if (Number($this.val()) > max_value) {
        $this.val(max_value);
    }
});