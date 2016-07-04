
DBCLI : A CLI utility for DBA (Oracle/MySQL/DB2)
=====================================================

[![Join the chat at https://gitter.im/hyee/dbcli](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hyee/dbcli?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![MIT License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)
[drag]:help.gif
![][drag]
![sshot-13](https://cloud.githubusercontent.com/assets/761520/14856219/d23eccbe-0cc9-11e6-9256-7275e91656d8.jpg)

Description
-----------------------

DBCLI is a portable database command line utility, for DBA or application support to easily manage and run their common used scripts, similar to database built-in CLI tools but is more flexible.  

It is mainly developed by Lua language, and bridges to JDBC to access database, many of the files are SQL scripts that easy to maintain.<br/> 
It is designed to support multiple databases, and includes 2 types of modules, one is the public module whose functions are visible across all database platforms, 
and another one is the platform-specific module.

Currently only public and Oracle/MySQL/DB2 functions are developed, and only support windows platform.

It is not intended to support all features of the existing CLI utilities that embedded by the specific database(`Oracle SQL*Plus`, `DB2 CLP`, etc), but to provide the features other than those tools:

* Pretty-print of the select statement and the flexible control of the grid layouts(see set command)
* Automatically generate help documents for customized SQL/shell/etc scripts.
* The `alias` command to reduce the frequent inputs
* The powerful `snap` and `ora` commands as the replacement of the standard CLI scripts, so that DBA is able to quickly define and execute the SQL templates with the smallest input
* Support SSH operations
* Provides the graph charts of the database performance, refer to the "chart" command
* Easy to extend, modify or deploy, because most of the source code is not required to compile
* Easily switch to the db built-in cli utility


Build and Configuration
-----------------------
DBCLI does not require compile or installation, but depends on JRE 1.7+. Click `Download ZIP`, extract and use.<br/> 
Branch `With-JRE` contains the shrinked                 JRE bundle, if you don't have JRE installed, you may switch to that branch to download. Due to the region and charset differences, this JRE bundle is not guaranteed to work well.<br/>
###Configure terminal window
To avoid the word wrap in the terminal window which affects the print layout, following settings are recommended in Windows command window:

* In the `Layout` tab, set buffer width and buffer height as `500+`
* In the `Font` tab, change the font size as smaller value.

###Configure environment
Before running dbcli, make sure that you have installed JRE 1.7+ in your local PC. If you are using the version of "With-JRE" branch, this step can be skipped.

Create file `init.cfg` under the "data" directory with following content:
   
    SET JRE_HOME=<JRE HOME>
    SET TNS_ADM=<location of tnsnames.ora>
    
Of which `TNS_ADM` is optional unless you need to connect Oracle via tnsnames.ora, or may also refer to `init_sample.cfg` for more settings. An example is:
   
    SET JRE_HOME=d:\soft\java
    SET TNS_ADM=d:\Soft\InstanceClient\network\admin

###Launch DBCLI Console
After the above configurations, you are able to start DBCLI by executing `dbcli.bat` or `bin\ConsoleZ\Console.exe`.

`dbcli.bat` also supports arguments in `"<command>=<args>"` format, all available commands can be found by typing `help` or `help -a`.

For example: `dbcli.bat "connect=tiger/scott@orcl"`



###Switch Database Platform
DBCLI supports multiple database platforms(oracle,mysql,db2,etc), default is `Oracle`.

To permanently change the preferred platform other than `Oracle`, run `set -p platform <platform>` after launching the console. 
For example, `set -p platform db2`

Without the `-p` option, the change only takes affect on current console window. 
Type `set platform` to see all available options.

Quick Start
-----------------------
Below are some common uses of the utility:


    1. "conn" or "connect" to connect to the database with or without installing Oracle client, and "reconn"  to re-connect.
    2. "login" command to connect to the db without password via the account that has been connected before. 
    3. Execute SQL statements which should match the database syntax, similar to SQL*Plus.
    4. "ora","show","sys" commands to execute pre-defined scripts. i.e., ora ashtop, ora actives  
    5. "alias" command which is similar to the Linux command
    6. "set" command to configure the shell environment
    7. 'q' or CTRL + D or CTRL + C to abort running command
    8. "help" or "help -a" to see other available commands
    9. 'chart' or 'ch' command to generate performance charts based on customize configs

Command Types
-----------------------
The command rules are similar to SQL*Plus:
* DDL commands that related to creating source code(`create trigger/package/function/procedure/type`) are cross-lines commands and should be end with `/` in a stand-alone line. `create table/index/etc` are not of this kind because they are related to structures.
* Other DML,DDL,DCL commands are also cross-lines commands that end with either `;`, or `/` in a new line.
* Command `SET COMMAND_ENDMARKS` is used to customize those 2 symbols.
* Apart from the above commands, most of other commands are single line commands and will be executed after the `Enter` key is pressed.
Type `help -a` and refer to the `Cross-lines` field for the type of each command. 

References
-----------------------
The utility depends on some binary files of open-source projects, the authors own the rights. 
The binaries have been included into this project.
Below is the list:

    JLine2      : (BSD)    https://github.com/jline/jline2
    JSch        : (BSD)    http://www.jcraft.com/jsch/
    ConsoleZ    : (GNU)    https://github.com/cbucher/console
    luajit v2.1 : (MIT)    https://github.com/LuaJIT/LuaJIT
    jnlua       : (MIT)    https://github.com/hyee/JNLuaJIT(revised from jnlua.googlecode.com)
    OpenCSV     : (MIT)    https://github.com/hyee/OpenCSV(revised from opencsv.sourceforge.net)
    MessagePack : (MIT)    https://github.com/fperrad/lua-MessagePack (pure lua)
    dygraphs    : (MIT)    https://github.com/danvk/dygraphs
    JsonForLua  : (MIT)    https://github.com/craigmj/json4lua 
    PSCP        : (MIT)    http://www.putty.org/ 
    LPeg        : (MIT)    http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html
    JNA         : (LGPL)   https://github.com/java-native-access/jna
    NuProcess   : (Apache) https://github.com/brettwooldridge/NuProcess
    Luv(libuv)  : (Apache) https://github.com/luvit/luv
    ANSICON     : (ZLIB)   https://github.com/adoxa/ansicon

Besides, some SQL scripts come from internet.

About ANSI Color Escapes
------------------------------------
`Win10` command window has natively supported the `xterm` ANSI escapes.

For lower Windows versions, `ANSICON` supports more ANSI escapes features than JLine, especially when running bash commands(i.e.: top) via SSH.

If you have concern on `ANSICON`, please remove it from bin, and edit `data\init.cfg` to add line `set ANSICON_CMD=`


Customize Commands
------------------------------------

###Customize new simple commands
You are able to use command `alias` to define the shortcut of the simple command, for instance:<br/>
`alias sf select * from (select * from $*) where rownum<=50;`

In this case, you can execute `sf dba_objects where object_id<1000` to simplify the input.

The `alias` command supports the `$1-$9` and `$*` wildcard characters, of which `$n` corresponds to the `n`th parameter, and `$*` means the concatenation of `$n+1`-`$9` via space. 
Type `alias` to see more usage.
 
###Customize new sub-command from complex SQLs
Take command `ora` for example, to define a sub-command `xxx`, create file ``oracle\ora\xxx.sql` and fill with following content: <br/>
`alias sf select * from (select * from &V1) where rownum<=50;`

After that, run `ora -r` to take effect, then you can run `ora xxx dba_objects` to query the view.

The utility has created some pre-defined commands, if you want to modify the those commands without concern of overriding back by the updates, just create a sub-folder under the `ora` directory, and put the updated file into it, because for the scripts with same name, the one in the sub directory will be treated as higher priority. Or you may also use `ora -l <path>` to link to another work dir.

Commands `ora/show/sys/snap/chart/sql/shell/etc` follow the similar rules:
* Parameters: Accept `:V1-:V20` or `&V1-&V20` as the input parameters, of which `:Vn` means binding parameters, and `&Vn` means replacing text.
* Help comment: `/*[[...]]*/` is optional, as the help or usage information
* Options: `--[[...]]--` inside the help comment is also optional, normally used to specify the command options(i.e., `ora actives -m`) and access validation, refer to other sub-commands for more examples.

###Customize new root command
Different from sub-commands, the root command must be a lua script. To plug a user-define lua script into the utility, just add its path in `data\plugin.cfg`, you may refer to `data\plugin_sample.cfg` for the example.

Below are the common interfaces that can be used in the script:
*  Define new command: `env.set_command(...)`
*  Define new setting: `env.set.init_cfg(...)`
*  Get current database: `env.getdb()`
You may also:
* Execute `help -a` or `set -a` to see how those interfaces are used in other scripts
* Execute `help -e env[.module] 2` to see the available interfaces