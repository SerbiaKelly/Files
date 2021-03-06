# 网络游戏同步

### 状态同步

- 状态同步是通过每个客户端发送自己的操作给服务器，这时客户端不进行任何动作，服务器统一计算后并把结果同步个每一个客户端

### 帧同步

- 帧同步是在关键帧的时候同步操作给服务器，服务器转发操作给每个客户端。客户端之间要接受到关键帧才可以进行操作

- 帧同步里面有一个关键技术就锁帧，也就是如果没有收到广播的关键帧不能进行下一步操作。大家静止不动
  而现在的游戏会有一个聪明一点的方法叫做乐观帧锁定,乐观帧锁定通过定时发送关键帧的方法，不锁定任何客户端，服务器一定时间间隔就发包给每个客户端，包里可能是空包也有可能是你自己活着别人的操作。而客户端就通过定时或者每当操作就发包的形式告诉服务器自己的操作

# Unity打包Apk PlayerSettings

- Company Name:公司名
- Product Name:安装后显示的包名
- Package Name:包ID (com.CompanyName.ProductName)

# SDK

渠道SDK:多平台出包上线，各平台监测渠道统计，提供运营分析（QuickSDK，易接）

openinstall:免打包渠道统计(https://www.openinstall.io/)

# IOS Xcode

# C#

### C# &与&& 和 |与||的区别

- &：按位与，对两个条件都进行判断

- &&：逻辑与，只要一个条件满足，另外一个条件就不会执行

- &优先级高于&&,&可以对两个整型数据，按照二进制位，逐位进行“与”运算，其运算结果版为整型，

  &还可以对两个逻辑型数据进行“与”运算，期盼结果为逻辑型数据；

  而&&则只能对两个逻辑型数据进行“与”运算，其运算结果为逻辑型数据。

- |：按位或,对两个条件都进行判断

- ||：逻辑或，只要一个条件满足，另外一个条件就不会执行

# 程序运算

- ###### 算数运算：加减乘除 + - * / %

- ###### 关系运算：比较运算 == != < > >= <=

- ###### 逻辑运算：与或非&& || ! ^ $ |

- ###### 位运算：*1.位运算是以二进制位为单位进行的运算,其操作数和运算结果都是整型值。 位运算符共有7个,分别是:位与(&)、位或(|)、位非(~)、位异或(^)、右移(>>)、左移(<<)、0填充的右移(>>>)。*

  *2.位运算的位与(&)、位或(|)、位非(~)、位异或(^)与逻辑运算的相应操作的真值表完全相同,其差别只是位运算操作的操作数和运算结果都是二进制整数,而逻辑运算相应操作的操作数和运算结果都是逻辑值。*

# Unity编辑器扩展

介绍：不需要将他们打包进工程，脚本放入名字是**Editor**的文件夹下

##### MenuItem特性

1. 添加自定义菜单项到Unity的大部分面板
2. MenuItem是能做用于静态方法，因为Unity需要通过类名来调用
3. enuItem特性的方法可以放在任何脚本中
4. MenuItem的三个参数（string itemName, bool isValidateFunction,int priority）

- string itemName：按钮方法的路径
- bool isValidateFunction：这个方法只有在选中对象的情况下可以调用，没选中对象就无法调用
- int priority：按钮在列表里的显示顺序和分组情况

##### 给脚本组件添加右键扩展方法按钮

//CONTEXT(固定写)/组件名/按钮名
    [MenuItem("CONTEXT/BoxCollider/ChangeTrigger")]
    static void ChangeCollider(MenuCommand cmd)//MenuCommand是当前正在操作的组件对象（这个参数不用传递，系统会帮传递）
    {
        //拿到对应的组件
        //这里使用（BoxCollider）转型如果失败会直接报错，使用as转型如果失败会返回Null，并且本行不会报错
        BoxCollider collider = cmd.context as BoxCollider;
        //isTrigger属性取反
        collider.isTrigger = !collider.isTrigger;

}