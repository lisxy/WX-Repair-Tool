# 微X 配置备份

本存储库旨在存储微 X 模块的配置。
为便于表述，本仓库中定义的微 X 模块包含 2.x 系列的微 X 模块和 3.0 版本的 X 模块。

要修复微 X 模块，请依次执行以下操作。

- 做好所需的准备，例如[隐藏 LRFP 环境](https://github.com/LRFP-Team/LRFP/blob/main/Bypassers/)；
- 安装最新版 WX Repair Tool 插件（本存储库记录的公开的最新版是 ``v2.0``）；
- 激活微 X 模块和 WX Repair Tool 两个插件；
- 在（非虚拟）注入框架中设置两个插件的作用域为仅微信；
- 人工或通过本存储库中的脚本导入适配的核心数据和 FKZ_WX_DATA 文件；以及
- 重启微信。

请安装最新版 WX Repair Tool，激活微 X 模块和 WX Repair Tool，导入适配的核心文件和 FKZ_WX_DATA，并重启微信。
为安全起见，请配置隐藏应用列表或其变种中的一个以保持微信无法在应用列表中检测到微 X 模块和 WX Repair Tool。
由于来自中国大陆的应用程序（例如微信、云闪付和中国银行）不仅会检测 LRFP 环境，还会检测境外应用（例如 Telegram），
请考虑[猫和老鼠游戏](https://github.com/LRFP-Team/LRFP/blob/main/Bypassers/HMA.md)。

已正常使用过微 X 模块且未清除或重置 FKZ_WX_DATA 的用户可能不需要导入 FKZ_WX_DATA，
要导入的 FKZ_WX_DATA 可能不需要同时适配微信和微 X 模块版本也能成功修复微 X 模块。
本存储库的配置数据备份源于五湖四海，请在导入后自行测试是否可用。
测试时，请以实际功能而非 WX Repair Tool 的检验结果或微 X 模块的用户界面（User Interface，简称 UI）为准。

欢迎各位朋友向本仓库提交核心文件和 FKZ_WX_DATA 备份。其中，由于 FKZ_WX_DATA 可能含有 WXID 信息，介意者请勿向本仓库提交 FKZ_WX_DATA。
在此，我们向提供配置数据的朋友们一并表示感谢。

## 架构

架构总览如下。为方便单独下载，每个基层文件夹都被转换为了一个压缩包，压缩包内容与原文件夹相同，下载后需要解压后使用。有关基层文件夹的定义和内容，请参阅下文。

```
├─核心文件
│  ├─8.0.49
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─……
│  ├─8.0.48
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─……
│  └─……
│      └─……
└─FKZ_WX_DATA
    ├─8.0.49
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─……
    ├─8.0.48
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─……
    └─……
        └─……
```

### 核心文件

在本存储库中，核心文件的下一层为微信版本；再下一层为插件版本，即为需要被复制的文件夹。
我们定义该文件夹为基层文件夹，核心文件的基层文件夹中含有若干文件，也可能含有文件夹。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹（例如 wx6_2.44）复制到您安卓设备的以下两个目录下（第二个目录不是必须的），
向目录授予 755 权限，并向其子文件夹（如有）和子文件分别授予 755 和 644 权限。
随后，请将这两个目录及目录内的所有内容的所有者和用户组均设置为微信应用。

- ``/data/user/0/com.tencent.mm/files/``
- ``/sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/``

即，以 wx6_2.44 为例，操作完成后，在您的安卓设备中，以下两个目录应当存在且非空，其权限为 755，其里面的文件夹（如有）的权限为 755，其里面的文件的权限为 644。
两个目录及目录内的所有内容的所有者和用户组均应已被设置为微信应用。同理，第二个目录不是必须的。

- ``/data/user/0/com.tencent.mm/files/wx6_2.44/``
- ``/sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/``

此外，如果您所使用的微信位于多用户系统中，请将以上操作中的目录 /data/user/0/com.tencent.mm/files/ 中的 0 替换为您的用户 ID，例如 999。

### FKZ_WX_DATA

已正常使用过微 X 模块且未清除或重置 FKZ_WX_DATA 的用户可能不需要导入 FKZ_WX_DATA，
要导入的 FKZ_WX_DATA 可能不需要同时适配微信和微 X 模块版本也能成功修复微 X 模块。

在本存储库中，FKZ_WX_DATA 的下一层为微信版本；再下一层为插件版本，里面的文件即为需要被复制的文件。

我们定义指示插件版本的文件夹为基层文件夹，FKZ_WX_DATA 的基层文件夹中含有若干个文件名以 ``FKZ_WX_`` 开头的文件，不含有文件夹。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹中文件名以 ``FKZ_WX_`` 开头的文件复制到您安卓设备的以下两个目录下，其中第二个目录不是必须的。

请将被复制过去的文件的权限、所有者、用户组分别设置为 660、微信应用和微信应用。

- ``/data/data/com.tencent.mm/databases/``
- ``/sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/``

即，操作完成后，在您的安卓设备中，以下目录应当存在且为非空。被复制过去的文件的权限、所有者、用户组应已被分别设置为 660、微信应用和微信应用。同理，第二个目录不是必须的。

- ``/data/data/com.tencent.mm/databases/``
- ``/sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/``

## Shell 命令

为了更好的体验，本存储库提供了一些 shell 脚本。这些脚本可以在 MT 管理器或 Termux 中执行，若在 MT 管理器中执行，请使用系统环境。

如需使用联网功能（如下载），请确保执行该脚本的载体能够正常访问 GitHub。

此外，在虚拟注入框架下使用微 X 模块不会得到这些脚本的支持，此行为的风险极高，是极为不推荐的。

再次提醒，请人工或使用生成式人工智能工具审阅代码后再执行 shell 脚本，尤其是那些需要 root 权限的脚本。

### ``autoImport.sh``

在安卓设备上使用 root 权限执行后，该脚本将根据设备环境在本存储库中查找对应的文件。
查找成功后，该脚本会将微 X 模块的核心文件和 FKZ_WX_DATA 下载到安卓设备上并自动完成导入。

### ``interactiveImport.sh``

该脚本会与用户交互，若无 root 权限，一些功能将不可用。

## 常见异常处理

此处提供一些 WX Repair Tool 中常出现的异常的处理方式。

### hookFail 可疑

该异常往往伴随核心文件数据文件数不正确或版本适配错误的异常出现，
导入同时适配于所使用的微信和微 X 模块版本的核心文件数据即可处理该异常。

### verifier6_time 或 verifier6 异常

该异常通常出现于使用具有 root 权限的 MT 管理器导入 FKZ_WX_DATA 后，
将导入的 FKZ_WX_DATA 的所有者和用户组均设置为微信应用即可解决该异常。

### 修复且正常使用微 X 模块一段时间后在设置能正常看到插件入口但未没有实际效果

核心文件或 FKZ_WX_DATA 的权限被更改，请通过 MT 管理器或执行 shell 命令手动修复权限，或使用本存储库的脚本重新导入以进行修复。

## 使用许可

本存储库的使用许可遵从上游使用许可，即基于微 X 模块和 WX Repair Tool 的使用许可开放使用。

## 致谢

- 微信防撤回（微 X 模块前身）：[https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- 微 X 模块：[https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://wwbg.lanzoub.com/iEhha2yg9ehi](https://wwbg.lanzoub.com/iEhha2yg9ehi)：``./核心文件/Play 8.0.33 (2306)/wx6_2.44``

“光阴似箭，日月如梭。”
不知不觉间，微 X 模块的服务器已经停止运行，我们将永远缅怀勇于改变世界的先驱者们。
“时间扑面而来，我们终将释怀。”
