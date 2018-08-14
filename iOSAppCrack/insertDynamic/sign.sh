#def var 声明变量等号(=)后面不能有空格，否者变量就是空了
APPNAME=${TARGET_NAME}
LIBNAME="libinsertDynamic"
IDENTIFIER=${PRODUCT_BUNDLE_IDENTIFIER}
STORYBOARD="InsertStoryboard"

#replace sign
plutil -replace application-identifier -string R9FM9QJB4R.${IDENTIFIER} Entitlements.plist
plutil -replace keychain-access-groups -xml "<array><string>R9FM9QJB4R."${IDENTIFIER}"</string></array>" Entitlements.plist
rm -rf ${APPNAME}.app/embedded.mobileprovision
cp LatestBuild/${APPNAME}.app/embedded.mobileprovision ${APPNAME}.app/

#insertlib
rm -rf ${APPNAME}.app/${LIBNAME}.dylib
mv LatestBuild/${LIBNAME}.dylib ${APPNAME}.app/

#storyboard
rm -rf ${APPNAME}.app/${STORYBOARD}.storyboardc
mv LatestBuild/${APPNAME}.app/${STORYBOARD}.storyboardc ${APPNAME}.app/

#codesign
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" ${APPNAME}.app/${LIBNAME}.dylib
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" --entitlements Entitlements.plist ${APPNAME}.app

#instead of app
rm -rf LatestBuild/${APPNAME}.app
cp -R ${APPNAME}.app LatestBuild/
