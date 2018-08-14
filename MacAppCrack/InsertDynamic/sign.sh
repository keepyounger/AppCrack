APPNAME=${TARGET_NAME}
LIBNAME="libinsertDynamic"

rm -rf ${APPNAME}.app/Contents/MacOS/${LIBNAME}.dylib
mv LatestBuild/${LIBNAME}.dylib ${APPNAME}.app/Contents/MacOS/

rm -rf LatestBuild/${APPNAME}.app
cp -R ${APPNAME}.app LatestBuild/
