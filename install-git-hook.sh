
# Create test directory
mkdir -p tests tests/hooks tests/non-ui tests/ui

# Write test hook

echo 'mocha $(find "tests/non-ui" -name "*.js")' > tests/hooks/non-ui-test-hook
chmod +x tests/hooks/non-ui-test-hook

echo 'mocha $(find "tests/ui" -name "*.js")' > tests/hooks/ui-test-hook
chmod +x tests/hooks/ui-test-hook

touch tests/hooks/post-pull
chmod +x tests/hooks/post-pull

# ========
# Check if pre-commit file exists
PRE_COMMIT_FILE=.git/hooks/pre-commit 
if [ -e "$PRE_COMMIT_FILE" ]; then
# Take backup of pre-commit file
mv $PRE_COMMIT_FILE "$PRE_COMMIT_FILE.backup"
fi
# ========

# Check if post-update file exists
POST_COMMIT_FILE=.git/hooks/pre-commit 
if [ -e "$POST_COMMIT_FILE" ]; then
# Take backup of pre-commit file
mv $POST_COMMIT_FILE "$POST_COMMIT_FILE.backup"
fi
# ========

# write code to pre-commit file
cat > .git/hooks/pre-commit << EOM
#Colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Javascript unit tests 
res=$(script -q /dev/null ./tests/hooks/non-ui-test-hook )
RESULT=$?
[ $RESULT -ne 0 ] && echo -e "$res" && exit 1
echo -e "All test cases passed.\n"
exit 0
EOM

chmod +x .git/hooks/pre-commit

cat > .git/hooks/post-update << EOM
#Colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Javascript unit tests 
res=$(script -q /dev/null ./tests/hooks/post-pull)
RESULT=$?
[ $RESULT -ne 0 ] && echo -e "$res" && exit 1
echo -e "All test cases passed.\n"
exit 0
EOM
chmod +x .git/hooks/post-update