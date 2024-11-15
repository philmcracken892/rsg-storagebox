game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'marcus'
description 'A Script That Would Allow medics To carry a storagebox'
version '1.0.2'

shared_scripts {
    '@ox_lib/init.lua',
	"configs/**.lua"
}

server_script {
    "server/**.lua"
}

client_script {
    "client/**.lua"
}

escrow_ignore {
    "configs/**.lua",
    "README.lua"
}



dependencies {
    'rsg-core',
    'rsg-target',
	'ox_lib'
}

lua54 'yes'
this_is_a_map 'no'
