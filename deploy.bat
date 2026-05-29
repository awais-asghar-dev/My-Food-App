@echo off
echo 🚀 Step 1: Building Flutter Web App...
call flutter build web --base-href "/My-Food-App/"

echo 📦 Step 2: Deploying Live Website to gh-pages...
cd build\web
git add .
git commit -m "Auto-update website"
git push -f origin master:gh-pages

echo 💻 Step 3: Backing up main Source Code...
cd ..\..
git add .
git commit -m "Auto-save progress"
git push origin master

echo 🎉 Success! Your live site and source code are updated.
pause