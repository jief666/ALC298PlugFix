# AL298PlugFix
> ALCPlugFix-298版本仅适用于 ALC298


## ALCPlugFix能做什么?(摘自daliansky)
* 它可以解决耳机插拔状态的切换
* 它是通过使用命令: `hda-verb 0xNode SET_PIN_WIDGET_CONTROL 0xVerbs`的方式进行状态切换
    * `hda-verb`的由来
    * `hda-verb`是linux下面的`alsa-project`的一条命令，它的作用是发送HD-audio命令 

## 如何使用?
1. 前往[https://github.com/jardenliu/ALC298PlugFix/releases](https://github.com/jardenliu/ALC298PlugFix/releases) 下载最新版的`release.zip`

# 鸣谢
- [goodwin](https://github.com/goodwin/ALCPlugFix) ALCPlugFix作者
- [daliansky](https://github.com/daliansky/ALCPlugFix) 提供了修改方法
- [Rehabman @EAPD-Codec-Commander](https://github.com/RehabMan/EAPD-Codec-Commander ALC298)提供的节点信息
