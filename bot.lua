db = require("./libs/redis")
config = loadfile('./config.lua')()
sudo_users = config.sudo_users
help = config.help
run = os.time()
print('bot runing')
function dl_cb(arg, data);end
function ok_cb(arg, data):end
function view();tdcli_function ({ID = "ViewMessages",chat_id_ = chat_id,message_ids_ = {[0] = m} }, dl_cb, nil);end
function getParseMode(parse_mode) if parse_mode then local mode = parse_mode:lower();if mode == 'markdown' or mode == 'md' then;P = {ID = "TextParseModeMarkdown"} elseif mode == 'html' then P = {ID = "TextParseModeHTML"} end end return P end
function send(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode);local TextParseMode = getParseMode(parse_mode);tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = disable_notification,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = disable_web_page_preview,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil);end
function is_sudo(msg) local var=false for k,v in pairs(sudo_users) do;if tostring(v):match(tostring(u_id))  then;var = true;end;end;return var;end
function addkon(chat_id,user_id,forward_limit)tdcli_function ({ID = "AddChatMember",chat_id_ = chat_id,user_id_ = user_id,forward_limit_ = forward_limit}, dl_cb, nil);end
function users(arg, data);for i=0, #data.users_ do;if arg.ard == 'addmember' then;addkon(arg.ch_id, data.users_[i].id_, 20);end;db:sadd('users',data.users_[i].id_);end;end
function add_member(msg);local users = db:smembers('users');for k,v in pairs(users) do;addkon(ch_id, v, 20);end;end
function math:source(t);local h,m,mo,d = 0,0,0,0;if t > 60 then while t > 60 do t = t - 60 m = m + 1 end end;if m > 60 then while m > 60 do m =  m - 60 h = h + 1 end end;if h > 24 then while h > 24 do h =  h - 24 d = d + 1 end end;if d > 30 then while d > 30 do d =  d - 30 mo = mo + 1 end end;return  mo..'month '..d..'day '..h..'hour '..m..'min '..' '..t..'s';end
function save_phone(phone_number, first_name, last_name, user_id);tdcli_function ({ID = "ImportContacts",contacts_ = {[0] = {phone_number_ = tostring(phone_number), first_name_ = tostring(first_name), last_name_ = tostring(last_name), user_id_ = user_id},},}, dl_cb, nil);end
function re_load_config();config = loadfile('./config.lua')() sudo_users = config.sudo_users;end
function contact(query, limit, cb, cmd) tdcli_function ({ID = "SearchContacts",query_ = query,limit_ = limit}, cb or ok_cb, cmd) end
function reply(text) send(ch_id, m, 1, text, 1, 'md');end
function fwd(chat_id, from_chat_id, message_ids, disable_notification)tdcli_function ({ID = "ForwardMessages",chat_id_ = chat_id,from_chat_id_ = from_chat_id,message_ids_ = message_ids,disable_notification_ = disable_notification,from_background_ = 1}, dl_cb, nil);end
function get_msg(chat_id, message_id, cb, cmd);tdcli_function ({ID = "GetMessage",chat_id_ = chat_id,message_id_ = message_id}, cb or ok_cb, cmd);end
function add_to_all(arg,data);uid,hash = data.sender_user_id_,{'supergroups',"groups"} for x,y in pairs(hash) do for k,v in pairs(db:smembers(y)) do addkon(v, uid, 20);end;end;reply('*user ['..uid..'] has been added to my groups*');end
local snum = {[tostring(1/0)]='1/0 --[[math.huge]]',[tostring(-1/0)]='-1/0 --[[-math.huge]]',[tostring(0/0)]='0/0'}
local badtype = {thread = true, userdata = true, cdata = true}
local keyword, globals, G ,serialized = {}, {}, (_G or _ENV)
for _,k in ipairs({'and', 'break', 'do', 'else', 'elseif', 'end', 'false','for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat','return', 'then', 'true', 'until', 'while'}) do keyword[k] = true end
for k,v in pairs(G) do globals[v] = k end 
for _,g in ipairs({'coroutine', 'debug', 'io', 'math', 'string', 'table', 'os'}) do
for k,v in pairs(G[g] or {}) do globals[v] = g..'.'..k end end
local function s(t, opts)
  local name, indent, fatal, maxnum = opts.name, opts.indent, opts.fatal, opts.maxnum
  local sparse, custom, huge = opts.sparse, opts.custom, not opts.nohuge
  local space, maxl = (opts.compact and '' or ' '), (opts.maxlevel or math.huge)
  local iname, comm = '_'..(name or ''), opts.comment and (tonumber(opts.comment) or math.huge)
  local seen, sref, syms, symn = {}, {'local '..iname..'={}'}, {}, 0
  local function gensym(val) return '_'..(tostring(tostring(val)):gsub("[^%w]",""):gsub("(%d%w+)",
    -- tostring(val) is needed because __tostring may return a non-string value
    function(s) if not syms[s] then symn = symn+1; syms[s] = symn end return tostring(syms[s]) end)) end
  local function safestr(s) return type(s) == "number" and tostring(huge and snum[tostring(s)] or s)
    or type(s) ~= "string" and tostring(s) -- escape NEWLINE/010 and EOF/026
    or ("%q"):format(s):gsub("\010","n"):gsub("\026","\\026") end
  local function comment(s,l) return comm and (l or 0) < comm and ' --[['..tostring(s)..']]' or '' end
  local function globerr(s,l) return globals[s] and globals[s]..comment(s,l) or not fatal
    and safestr(select(2, pcall(tostring, s))) or error("Can't serialize "..tostring(s)) end
  local function safename(path, name) -- generates foo.bar, foo[3], or foo['b a r']
    local n = name == nil and '' or name
    local plain = type(n) == "string" and n:match("^[%l%u_][%w_]*$") and not keyword[n]
    local safe = plain and n or '['..safestr(n)..']'
    return (path or '')..(plain and path and '.' or '')..safe, safe end
  local alphanumsort = type(opts.sortkeys) == 'function' and opts.sortkeys or function(k, o, n) -- k=keys, o=originaltable, n=padding
    local maxn, to = tonumber(n) or 12, {number = 'a', string = 'b'}
    local function padnum(d) return ("%0"..tostring(maxn).."d"):format(tonumber(d)) end
    table.sort(k, function(a,b)
      -- sort numeric keys first: k[key] is not nil for numerical keys
      return (k[a] ~= nil and 0 or to[type(a)] or 'z')..(tostring(a):gsub("%d+",padnum))
           < (k[b] ~= nil and 0 or to[type(b)] or 'z')..(tostring(b):gsub("%d+",padnum)) end) end
  local function val2str(t, name, indent, insref, path, plainindex, level)
    local ttype, level, mt = type(t), (level or 0), getmetatable(t)
    local spath, sname = safename(path, name)
    local tag = plainindex and
      ((type(name) == "number") and '' or name..space..'='..space) or
      (name ~= nil and sname..space..'='..space or '')
    if seen[t] then -- already seen this element
      sref[#sref+1] = spath..space..'='..space..seen[t]
      return tag..'nil'..comment('ref', level) end
    if type(mt) == 'table' and (mt.__serialize or mt.__tostring) then -- knows how to serialize itself
      seen[t] = insref or spath
      if mt.__serialize then t = mt.__serialize(t) else t = tostring(t) end
      ttype = type(t) end -- new value falls through to be serialized
    if ttype == "table" then
      if level >= maxl then return tag..'{}'..comment('max', level) end
      seen[t] = insref or spath
      if next(t) == nil then return tag..'{}'..comment(t, level) end -- table empty
      local maxn, o, out = math.min(#t, maxnum or #t), {}, {}
      for key = 1, maxn do o[key] = key end
      if not maxnum or #o < maxnum then
        local n = #o -- n = n + 1; o[n] is much faster than o[#o+1] on large tables
        for key in pairs(t) do if o[key] ~= key then n = n + 1; o[n] = key end end end
      if maxnum and #o > maxnum then o[maxnum+1] = nil end
      if opts.sortkeys and #o > maxn then alphanumsort(o, t, opts.sortkeys) end
      local sparse = sparse and #o > maxn -- disable sparsness if only numeric keys (shorter output)
      for n, key in ipairs(o) do
        local value, ktype, plainindex = t[key], type(key), n <= maxn and not sparse
        if opts.valignore and opts.valignore[value] -- skip ignored values; do nothing
        or opts.keyallow and not opts.keyallow[key]
        or opts.valtypeignore and opts.valtypeignore[type(value)] -- skipping ignored value types
        or sparse and value == nil then -- skipping nils; do nothing
        elseif ktype == 'table' or ktype == 'function' or badtype[ktype] then
          if not seen[key] and not globals[key] then
            sref[#sref+1] = 'placeholder'
            local sname = safename(iname, gensym(key)) -- iname is table for local variables
            sref[#sref] = val2str(key,sname,indent,sname,iname,true) end
          sref[#sref+1] = 'placeholder'
          local path = seen[t]..'['..tostring(seen[key] or globals[key] or gensym(key))..']'
          sref[#sref] = path..space..'='..space..tostring(seen[value] or val2str(value,nil,indent,path))
        else
          out[#out+1] = val2str(value,key,indent,insref,seen[t],plainindex,level+1)
        end
      end
      local prefix = string.rep(indent or '', level)
      local head = indent and '{\n'..prefix..indent or '{'
      local body = table.concat(out, ','..(indent and '\n'..prefix..indent or space))
      local tail = indent and "\n"..prefix..'}' or '}'
      return (custom and custom(tag,head,body,tail) or tag..head..body..tail)..comment(t, level)
    elseif badtype[ttype] then
      seen[t] = insref or spath
      return tag..globerr(t, level)
    elseif ttype == 'function' then
      seen[t] = insref or spath
      local ok, res = pcall(string.dump, t)
      local func = ok and ((opts.nocode and "function() --[[..skipped..]] end" or
        "((loadstring or load)("..safestr(res)..",'@serialized'))")..comment(t, level))
      return tag..(func or globerr(t, level))
    else return tag..safestr(t) end -- handle all other types
  end
  local sepr = indent and "\n" or ";"..space
  local body = val2str(t, name, indent) -- this call also populates sref
  local tail = #sref>1 and table.concat(sref, sepr)..sepr or ''
  local warn = opts.comment and #sref>1 and space.."--[[incomplete output with shared/self-references skipped]]" or ''
  print('(C) 2016-17 Nfs source; MIT License')
  return not name and body..warn or "--NFS source\nlocal "..body..sepr..tail.."return "..name..sepr.."--by behrad"
end
local function deserialize(data, opts)
  local env = (opts and opts.safe == false) and G
    or setmetatable({}, {
        __index = function(t,k) return t end,
        __call = function(t,...) error("cannot call functions") end
      })
  local f, res = (loadstring or load)('return '..data, nil, nil, env)
  if not f then f, res = (loadstring or load)(data, nil, nil, env) end
  if not f then return f, res end
  if setfenv then setfenv(f, env) end
  return pcall(f)
end
function merge(a, b) if b then for k,v in pairs(b) do a[k] = v end end; return a; end
function reply_conf(arg,data)
local uid = data.sender_user_id_
arg.func(uid)
end
function promote_sudo(uid)
u_id = uid
if is_sudo(msg) then
return reply(uid..'is already a sudoer.')
else
table.insert(config['sudo_users'],tostring(uid))
file = io.open('./config.lua', 'w+') 
block = function(a, opts) return s(a, merge({indent = '\n', sortkeys = true, comment = true}, opts)) end 
serialized = block(config, {comment = false,name = '_'}) 
file:write(serialized) 
file:close()
re_load_config()
reply(uid..'has been promote as sudo')
end
end

function demote_sudo(uid)
u_id = uid
if not is_sudo(msg) then
return reply(uid..'is not a sudoer.')
else
table.insert(config['sudo_users'],tostring(uid))
file = io.open('./config.lua', 'w+') 
block = function(a, opts) return s(a, merge({indent = '\n', sortkeys = true, comment = true}, opts)) end 
serialized = block(config, {comment = false,name = '_'}) 
file:write(serialized) 
file:close()
re_load_config()
reply(uid..'has been demote as sudo')
end
end

function to_msg(msg)
local text = msg.content_.text_:lower():gsub('[$!/#]','')
local x = string.match
if text == "/add" then
contact('', 500, users, {arg='addmember',ch_id=ch_id})
add_member(msg)
reply('member has been added')
end

if x(text,"^/bot$") then
local gps,sgp,users = db:scard("groups"),db:scard("supergroups"),db:scard('users')
local text =  "*اعضا :* "..users.."\nگروه های معمولی : "..gps.."\nابر گروه ها : "..sgp
reply(text)
end

if x(text,"^/sudolist$") then
local text = 'List of bot sudo users :'
for k,v in pairs(config['sudo_users']) do
text = text..'\n*-*'..k..' ~ '..v
end
reply(text)
end 

if text == "/ping" then
local t = os.difftime(os.time(),run)
time = math:source(t)
reply('*pong*'..'\n*time runing :* '..time..'')
end

if x(text,'^/reload$') then
dofile('bot.lua')
reply('*BOT Reloaded*')
end

local sudo_pat = {'^/(sudo) (.*)$','/^(sudo)$'}
for k,v in pairs(sudo_pat) do
local blocks = {x(text,v)}
if blocks then
if blocks[2] and tonumber(blocks[2]) then
return promote_sudo(x(blocks[2],'(%d+)'))
elseif msg.reply_to_message_id_ ~= 0 then
return get_msg(ch_id,msg.reply_to_message_id_,reply_conf,{func = promote_sudo})
end
end
end

local desudo_pat = {'^/(desudo) (.*)$','^/(desudo)$'}
for k,v in pairs(desudo_pat) do
local blocks = {x(text,v)}
if blocks then
if blocks[2] and tonumber(blocks[2]) then
return demote_sudo(x(blocks[2],'(%d+)'))
elseif msg.reply_to_message_id_ ~= 0 then
return get_msg(ch_id,msg.reply_to_message_id_,reply_conf,{func = demote_sudo})
end
end
end

if text == "/setbaner" and msg.reply_to_message_id_ ~= 0 then
db:st('banerid',msg.reply_to_message_id_)
db:st('gp',ch_id)
fwd(ch_id, gp, {[0] = msg.reply_to_message_id_}, 0)
m = msg.reply_to_message_id_
reply('*baner has been seted😀\nBaner id : *'..m)
end

if text == '/rembaner' then
db:del('banerid')
db:del('gp')
reply('*baner has been removed*')
end

if text == "getbaner" then
if db:get('banerid') then
return fwd(ch_id, gp, {[0] = db:get('banerid')}, 0)
end 
reply('baner not found')
end

if text == 'rconf' then
re_load_config()
reply('اطلاعات ربات جایگزین شد')
end

local y = x(text,'^/setspeed (.*)^')
if tonumber(y) then
db:st('speed',y)
reply('*bot speed ads has been changed to '..y..'*')
end

if x(text,'^/addall$') and msg.reply_to_message_id_ ~= 0 then
reply('please wait to add him to all my groups baby')
get_msg(ch_id,msg.reply_to_message_id_,add_to_all,nil)
end

if x(text,'^/echo (.*)$') then
reply(x(text,'echo (.*)'))
end
if x(text,'^/help$') then
reply(help)
end

if text:match("^fwd") and msg.reply_to_message_id_ then
local text = text:match("^fwd (.*)")
local a = 0
local text = text:match('(all)') or text:match('(user)') or text:match('(gp)')
if not text then
return reply('some thing was wrong')
end
if text == 'all' then hash = {'supergroups',"groups",'users'} elseif text == 'user' then hash = {'users'} elseif text == 'gp' then hash = {'supergroups',"groups"} end
for x,y in pairs(hash) do
for k,v in pairs(db:smembers(y)) do
fwd(v, ch_id, {[0] = msg.reply_to_message_id_}, 0)
a=a+1
end
end
reply('*done sended to* : '..a)
end
end
if not db:get("pv:msgs") then db:set("pv:msgs",1) end
if not db:get("gp:msgs") then db:set("gp:msgs",1)end
if not db:get("supergp:msgs") then db:set("supergp:msgs",1) end
function stats(msg)
if group_type(msg) == "user" then
if not db:sismember("users",ch_id) then db:sadd("users",ch_id) end
return db:incrby("pv:msgs",1)
end
local speed = db:get('speed')
if not db:get('time:ads:'..ch_id) and db:get('banerid') then
db:psetex('time:ads:'..ch_id, (speed or 855), true)
fwd(ch_id, gp, {[0] = db:get('banerid')}, 0)
end
if group_type(msg) == "chat" then
if not db:sismember("groups",ch_id) then db:sadd("groups",ch_id) end
return db:incrby("gp:msgs",1)
end
if group_type(msg) == "cahnnel" then
if not db:sismember("supergroups",ch_id) then db:sadd("supergroups",ch_id) end
return db:incrby("supergp:msgs",1)
end
end
function send_typing(progress)
tdcli_function ({ID = "SendChatAction",chat_id_ = ch_id,action_ = {ID = "SendMessageTypingAction",progress_ = progress or nil}}, dl_cb, nil)
end
function sleep(s)
  local ntime = os.time() + s
  repeat
  until ntime < os.time()
end
function addlist(msg)
local add_text = db:get('reply:text') or 'addi'
if  msg.content_ and msg.content_.contact_.ID == "Contact" then
save_phone(msg.content_.contact_.phone_number_, (msg.content_.contact_.first_name_ or '--'), '#bot', msg.content_.contact_.user_id_)
reply(add_text)
end
end

function group_type(msg);var = 'find'
  if type(ch_id) == 'string' then
  if ch_id:match('$-100') then;var = 'cahnnel'
  elseif ch_id:match('$-10') then;var = 'chat'
  end
else;var = 'user'
  end 
  return var
  end
  
function getMe(cb,cmd) tdcli_function ({ID = "GetMe",}, cb, cmd) end
function do_bot(arg, data) bot = {id = data.id_} end
function msg_rvc(data) 
  if not (data.ID == "UpdateNewMessage") then
  return
  end
  local msg = data.message_
  ch_id,gp,u_id,m = msg.chat_id_,db:get('gp'),msg.sender_user_id_,msg.id_	
   if msg.date_ - 5 > os.time() then ;return false ;end
	if u_id == 0 then
        print('\27[36mNot valid: msg from us\27[39m')
        return false
    end
	
	if not bot then
	return getMe(do_bot)
    end

	if u_id == bot.id then
	    print('\27[36mNot valid: msg from us\27[39m')
        return false
    end
	
	stats(msg)
	view() -- seen bazn jandeh
    if msg.content_.ID == "MessageText"  then
	if is_sudo(msg) then
     to_msg(msg)
    end
  end
  if msg.content_.contact_ and msg.content_.contact_.ID == "Contact" then
   addlist(msg)
  end
end
tdcli_update_callback = msg_rvc

