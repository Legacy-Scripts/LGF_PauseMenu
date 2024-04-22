fx_version 'adamant'
game 'gta5'

author 'ENTR510'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
}


client_scripts {
    'client/main.lua',
    'client/callback.lua',
    'client/function.lua',
}

server_scripts {
    'server/main.lua'
}

ui_page "nui/index.html"

files {
    "nui/index.html",
    "nui/styles.css",
    "nui/script.js",

}
