fx_version 'cerulean'
game 'gta5'
author 'ENTR510 (Forked by Jv$t)'
version '1.0.1'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page "nui/index.html"

files {
    "nui/index.html",
    "nui/styles.css",
    "nui/script.js",
    "locales/*.json",
    "modules/*.lua"
}