#def var 声明变量等号(=)后面不能有空格，否者变量就是空了
APPNAME=${TARGET_NAME}
LIBNAME="iOSHook"
IDENTIFIER=${PRODUCT_BUNDLE_IDENTIFIER}

#replace sign
plutil -replace application-identifier -string R9FM9QJB4R.${IDENTIFIER} Entitlements.plist
plutil -replace keychain-access-groups -xml "<array><string>R9FM9QJB4R."${IDENTIFIER}"</string></array>" Entitlements.plist
rm -rf ${APPNAME}.app/embedded.mobileprovision
cp LatestBuild/${APPNAME}.app/embedded.mobileprovision ${APPNAME}.app/
cp LatestBuild/${APPNAME}.app/Frameworks/* ${APPNAME}.app/Frameworks/*

#insertlib
rm -rf ${APPNAME}.app/${LIBNAME}.framework
cp -R LatestBuild/${LIBNAME}.framework ${APPNAME}.app/

EXEFILENAME=$(plutil -extract "CFBundleExecutable" xml1 ${APPNAME}.app/Info.plist -o temp.plist && plutil -p temp.plist)
EXEFILENAME=$(echo ${EXEFILENAME} | sed 's/\"//g')
insert-lib ${APPNAME}.app/${EXEFILENAME} ${LIBNAME}.framework/${LIBNAME}
rm -rf temp.plist

#codesign
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" ${APPNAME}.app/${LIBNAME}.framework
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" --entitlements Entitlements.plist ${APPNAME}.app

#instead of app
rm -rf LatestBuild/${APPNAME}.app
cp -R ${APPNAME}.app LatestBuild/
