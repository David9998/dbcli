
local db,string=env.getdb(),string

local sys=env.class(db.C.ora)
function sys:ctor()
    self.db=env.getdb()
    self.command={"sys","dba"}
    self.help_title=[[
        Run SQL script under the "sys" directory that needs SYSDBA role or the accesses to the xv$ views.
        The command contains the scripts that required the SYSDBA privilege. 
        For the non-sysdba user, the x$ views inside the scripts will be automatically renamed to xv$ views during the execution.
        These xv$ views wold be validated in runtime and determine if the script is accessible.
        Please refer to 'sys\xvcreate' or run 'sys xvcreate' to create the xv$ views for normal user.]]..'\n'
    self.script_dir,self.extend_dirs=self.db.ROOT_PATH.."sys",{}
end

local instance_pattern={
    string.case_insensitive_pattern('%f[%w_%$:%.](("?)x$%a[%w_%$]+%2)([%s%),;])'),
    string.case_insensitive_pattern('%f[%w_%$:%.]sys%. *(("?)x$%a[%w_%$]+%2)([%s%),;])'),
}

function sys:run_sql(sql,args,cmds,files)
    if type(sql)=="table" then
        for i=1,#sql do self:run_sql(sql[i],args[i],cmds[i],files[i]) end
        return;
    end
    local founds,count=0
    if not self.db.props.isdba then
        for _,pattern in ipairs(instance_pattern) do
            sql,count=sql:gsub(pattern,
                function(s1,s2,s3)
                    s1='SYS.XV'..s1:gsub('"',''):sub(2,29)
                    env.checkerr(db:check_access(s1),"View %s is not created or granted to current user!",s1)
                    return s1..s3 
                end)
            founds=founds+count
        end
        if founds==0 then founds=sql:find("%f[%w_%$:][Vv][Xx]_$%%a%w+") or 0 end
    end
    env.checkerr(self.db.props.isdba or founds>0,"You don't have the SYSDBA privilege!")
    return self.super.run_sql(self,sql,args,cmds,files)
end

return sys.new()