#!/usr/bin/env bash
# script pour supprimer les langues autres que fr et en
# principale source pour constantes : https://github.com/az0/bleachbit/blob/master/bleachbit/Unix.py

declare -a not=('en' 'fr') # on les garde !!!
declare -a locales=(
        'ar' 'ach' 'af' 'am' 'an' 'ang' "as" 'ast' 'az' 'az_IR' 'bal' 'be' 'be@latin' 'bg' 'bg_BR'
        'bn' 'bn_BD' 'bn_IN'
        'bs'
        'byn'
        'ca' 'ca_ES' 'ca@valencia' 'ca_ES@valencia'
        'cgg' 'co'
        'crh' 'ckb' 'csb'
         'cs' 'cs_CZ'
         'cz' 'cy'
         'da' 'da_DK'
         'de' 'dz'
         'el'
         'en_AU' 'en_GB' 'en@quot' 'en@shaw' 'en_CA' 'en_NZ'
         'eo'
         'es' 'es_MX'
         'et'
         'fa' 'da_IR'
         'fi'
         'ff'
         'fo'
         'fur' 'fy'
         'ga' 'gd' 'gr' 'gu'
         'gez'
         'gl' 'gl_ES'
         'ha' 'haw'
         'he' 'he_IL'
         'hi'
         'hne'
         'hsb'
         'hr'
         'hu'
         'hy'
         'ia'
         'id'
         'it'
         'iw'
         'ku'
         'ky'
         'lo'
         'lv'
         'ja' 'ja_JP'
         'jv'
         'lt'
         'ko' 'ko_KR'
         'ka' 'kab'
         'km' 'km_KH'
         'kg' 'kk' 'kn'
         'lg' 'li' 'lo_LA'
         'mk' 'mk_MK'
         'mr'
         'ms'
         'my'
         'nb'
         'nds'
         'nl'
         'no'
         'pl'
         'pt' 'pt_BR'
         'ro' 
         'ru'
         'sk'
         'sl'
         'sr'
         'sv'
         'tr'
         'tyv'
         'ug'
         'uk'
         'uz'
         'vi' 'vi_VN'
         'wal'
         'zh' 'zh_CN' 'zh_TW'
)

declare -ar dirs=(
    '/usr/share/man/' 
    '/usr/share/locale/'
    '/usr/share/i18n/locales/'
    '/usr/share/locale/kde4/'
    '/usr/share/kf5/kdoctools/customization/'
    '/usr/share/kf5/locale/countries/'
    '/usr/share/help/'
    '/usr/share/doc/kde/html/'
    '/usr/share/doc/HTML/'
    '/usr/share/apps/ksgmltools2/customization/'
    '/usr/share/cups/doc/'
    '/usr/share/cups/templates/'
    '/usr/share/foomatic/db/source/PPD/Kyocera/'
    '/usr/share/doc/thunar-data/html'
    '/usr/share/speedcrunch/books/'
    '/usr/share/vim/vim74/lang/'
    '/usr/share/anki/locale/'
    '/usr/share/zenmap/locale/'
    '/usr/share/lyx/doc/'
    '/usr/share/lyx/examples/'
    '/usr/share/lib/R/library/translations'
    '/usr/share/kbd/locale/'
    '/usr/share/X11/xkb/symbols/'
    '/usr/share/X11/xkb/symbols/sun_vndr/'
    '/usr/share/gnome/help/gparted/'
    '/usr/share/djvu/osi/'
    '/usr/share/zenmap/locale/'
    '/usr/share/virtualbox/rdesktop-vrdp-keymaps/'
)


    
have_delete=false
echo $1
[ "$1" == '-d' ] && have_delete=true
declare total=0
if [[ $EUID -ne 0 && "$have_delete" == true ]]; then
    echo -e "\n${0##*/} il faut des privileges root !\n"
    exit 1
fi

#doubler les valeurs si sont de 2 caracteres (fi_FI)
for locale in ${locales[*]} ; do
    long=${#locale}
    if [ $long == 2 ] ; then
        locales[${#locales[*]}]="${locale}_${locale^^}"
        echo "valeur doublée: ${locale}_${locale^^}"
    fi
done

containsElement () { for e in "${@:2}"; do [[ "$e" = "$1" ]] && return 0; done; return 1; }

for dir in ${dirs[*]} ; do
    #echo $dir
    if [ -d "$dir" ]; then
        for locale in ${locales[*]} ; do
            
            if containsElement $locale ${not[@]} ; then
                # par erreur en ou fr dans les locales ????
                echo -e "------------- \on efface pas le dossier $dir$locale\n -----------------"; 
                continue
            fi
            local_dir="$dir$locale"
            if [ -d "$local_dir" ] ; then
                echo "$local_dir ..."
                size=$(du -Lbcs $local_dir | tail -n 1 | awk '{print $1}' )
                let total+=$size
                echo "supprimer $size octets"
                [ $have_delete == true ] && $(rm -Rd $local_dir)
            fi
            if [ -f "$local_dir" ]; then
                echo "$local_dir ..."
                size=$(du -Lbcs $local_dir | tail -n 1 | awk '{print $1}' )
                let total+=$size
                [ $have_delete == true ] && $(rm $local_dir)
            fi            
        done
    fi
done
    
let "total= total / 1024"
echo "$total ko supprimés"