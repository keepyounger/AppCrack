#!/bin/bash

EXEPath=$1

if [ ! "$EXEPath" ]
then
    echo "没有参数！程序已经退出！"
    exit
fi

function stringInString
{
    STRING_A=$1
    STRING_B=$2

    if [[ ${STRING_B/${STRING_A}//} == $STRING_B ]]
    then
        echo ""
    else
        echo "1"
    fi
}

flag=$(stringInString ".app/[a-zA-Z]" "$EXEPath")

if [ ! $flag ]
then
echo "请补充到可执行文件.app/里面的路径！"
exit
fi

#app路径
APPPath=${EXEPath%/*}
echo "路径:"$APPPath

#可执行文件名称
EXEName=${EXEPath##*/}
echo "可执行文件名称:"$EXEName

#app名称
APPName=${APPPath##*/}
echo "app名称:"$APPName

echo "正在操作，请稍等..."

#转到桌面
mkdir ~/Desktop/"$EXEName"

cp -R ./insertDynamic ~/Desktop/"$EXEName"/

cd ~/Desktop

#转到新建目录
cd "$EXEName"

echo "正在复制APP..."
cp -R "$APPPath" ./

echo "正在复制可执行文件..."
#复制可执行文件
mkdir temp
cp "${APPName}"/"${EXEName}" temp

echo "正在修改可执行文件..."

insert-lib temp/"${EXEName}" libinsertDynamic.dylib > /dev/null 2>&1
temstr=$(lipo -info temp/"${EXEName}")
#echo $temstr

archs=${temstr##*:}
echo $archs

flag=$(stringInString "arm64" "$archs")
#echo $flag

armsPath=temp/"${EXEName}"

if [ "$archs" == " arm64" ]
then
    echo "arm64 only"
    cp "$armsPath" temp/arm64
    chmod +x temp/arm64
    rm "${APPName}"/"${EXEName}"
    cp temp/arm64 "${APPName}"/"${EXEName}"
elif [ "$flag" ]
then
    lipo "$armsPath" -thin arm64 -output temp/arm64
    chmod +x temp/arm64
    rm "${APPName}"/"${EXEName}"
    cp temp/arm64 "${APPName}"/"${EXEName}"
    echo "已自动选择arm64"
else
    lipo "$armsPath" -thin armv7 -output temp/armv7
    chmod +x temp/armv7
    rm "${APPName}"/"${EXEName}"
    cp temp/armv7 "${APPName}"/"${EXEName}"
    echo "已自动选择armv7"
fi

echo "正在签名..."
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" "${APPName}"/*/*.dylib  > /dev/null 2>&1
codesign -f -s "iPhone Developer: xiangyang li (UJM6S5B55K)" "${APPName}"/*/*.framework  > /dev/null 2>&1
#删除扩展程序
rm -rf "${APPName}"/*/*.appex
echo "签名完成"

echo "是否修改Bundle identifier？(y/n)"
read flag
if [ "$flag" == "y" ]
then
    echo "输入Bundle identifier："
    read BundleIdentifier
    plutil -replace CFBundleIdentifier -string ${BundleIdentifier} "${APPName}"/info.plist

fi

mv "${APPName}" insertDynamic/APP.app

rm -rf temp

echo "操作完成！"
