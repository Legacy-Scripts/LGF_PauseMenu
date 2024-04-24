fx_version 'adamant'
game 'gta5'

author 'ENTR510'
version '1.0.0'
lua54 'yes'

files {
    'config.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/function.lua',
    'client/callback.lua',
    'client/main.lua',
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
