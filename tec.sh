
 function start_bot() {
 # while true; do
 # ./tg -p $2 -s bot.lua
 ./tg  -C -A -R -b  -v -N -d -p $2 -s bot.lua
# done
 }
 
 function create_bot() {
  ./tg -p $2 -s bot.lua
 }
 
function rf() {
rm -rf config.lua
lua cr.lua
 }
 
function tg() {
  wget https://valtman.name/files/telegram-cli-1222
  mv telegram-cli-1222 tg
  chmod 777 tg
  
}

if [[ $1 == "-r" ]]; then
if [ ! -f "./tg" ]; then echo "Please install tg"; exit; fi
   echo "runing bot $2"
   start_bot $2
   exit
   elif [[ $1 == "-cr" ]]; then
if [ ! -f "./tg" ]; then echo "Please install tg"; exit; fi
   echo "creating bot $2"
   create_bot $2
   exit
 elif [[ $1 == "-list" ]]; then
 ls ../.telegram-cli
 elif [[ $1 == "-rf" ]]; then
 rf
 elif [[ $1 == "-tg" ]]; then
 tg
 elif [[ $1 == "-killall" ]]; then
 rm -rf ../.telegram-cli
 elif [[ $1 == "-help" ]]; then
 echo "Help for $0 sh script :"
 echo "$0 -help for see help"
 echo "$0 -list for see list of bots"
 echo "$0 -rf create new config"
 echo "$0 -cr <botname> for create a bot"
 echo "$0 -r <botname> for run bot with hash"
 echo "$0 -killall for delete all bots"
 echo "$0 -tg for install tg 1222"
 exit
fi
exit
