#!/bin/bash -e

repoUrl=`cat repository-url.txt`
releaseName=`cat release-name.txt`

if [ -z "$1" ]
then
    echo "Please, enter git tag version."
    exit
fi

tempFolder="tempGitRepo"

echo "Delete old temp folder"
rm -rf $tempFolder

echo "Git clone repository"
git clone -b $1 --single-branch $repoUrl $tempFolder

echo "Go to temp folder"
cd $tempFolder
git init

echo "Version of git repository is:"
git describe --tags

if [ -f "composer.json" ]
then
    echo 'Install composer...'
    export COMPOSER_HOME="$HOME/.config/composer";
    composer install

    if [ -f "artisan" ]
    then
        echo 'Generate key..'
        #php artisan key:generate
    fi
    echo 'Run php unit..'
    #./vendor/bin/phpunit
fi

repoTag=`git describe --tags`

cd ../

if [ ! -d $releaseName ]
then
    mkdir $releaseName
fi

zip -r "./"$releaseName"/"$releaseName"-"$repoTag".zip" $tempFolder

echo 'Done!'