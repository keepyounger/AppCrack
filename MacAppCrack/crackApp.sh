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

flag=$(stringInString "/Contents/MacOS/" "$EXEPath")

if [ ! $flag ]
then
    echo "请补充到可执行文件/Contents/MacOS/里面的路径！"
    exit
fi

#app路径
APPPath=${EXEPath%/Contents/MacOS/*}
echo "app路径:"$APPPath

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
cp "${APPName}"/Contents/MacOS/"${EXEName}" temp

echo "正在修改可执行文件..."

insert-lib temp/"${EXEName}" libinsertDynamic.dylib > /dev/null 2>&1
temstr=$(lipo -info temp/"${EXEName}")
#echo $temstr

archs=${temstr##*:}
echo $archs

rm "${APPName}"/Contents/MacOS/"${EXEName}"
cp temp/"${EXEName}" "${APPName}"/Contents/MacOS/"${EXEName}"

mv "${APPName}" insertDynamic/APP.app

rm -rf temp

echo "操作完成！"
