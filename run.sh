echo "Extracting image..."
tar xzf ./build.tar.gz
cd ./build
echo "Starting tests..."
time ../vm/Cog.app/Contents/MacOS/Squeak ./TravisCI.image ../scripts/run.st > ./time.log
echo "Done!"