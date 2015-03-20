/**
 * Created by zzy on 2015/3/20.
 */
/**
 * 删除左右两端的空格
 */
String.prototype.trim=function()
{
    return this.replace(/(^\s*)|(\s*$)/g,"");
}
/**
 * 删除左边的空格
 */
String.prototype.ltrim=function()
{
    return this.replace(/(^\s*)/g,"");
}
/**
 * 删除右边的空格
 */
String.prototype.rtrim=function()
{
    return this.replace(/(\s*$)/g,"");
}