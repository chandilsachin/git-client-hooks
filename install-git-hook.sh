
# Create test directory
mkdir -p tests tests/hooks tests/non-ui tests/ui

# Write test hook
cat > tests/hooks/non-ui-test-hook << EOM
#Colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Runing test cases
res=\$(script -q /dev/null mocha \$(find "tests/non-ui" -name "*.js"))
RESULT=\$?
[ \$RESULT -ne 0 ] && echo -e "\$res \${RED}Some TestCaes did not pass. Please check your code.\${NC}" && exit 1
echo "All test cases passed.\n"
exit 0
EOM
chmod +x tests/hooks/non-ui-test-hook

cat > tests/hooks/ui-test-hook << EOM
#Colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Runing test cases
res=\$(script -q /dev/null mocha \$(find "tests/ui" -name "*.js"))
RESULT=\$?
[ \$RESULT -ne 0 ] && echo -e "\$res \${RED}Some TestCaes did not pass. Please check your code.\${NC}" && exit 1
echo "All test cases passed.\n"
exit 0
EOM
chmod +x tests/hooks/ui-test-hook

touch tests/hooks/post-pull
chmod +x tests/hooks/post-pull

# ========
#Write a sample test case
cat > tests/non-ui/sample-test.js << EOM
var assert = require('assert');

describe("All element creation test:", function(){

    before(function () {

    });

    after(function () {

    });
    it("Label", function(){
        assert.equal(false, true)
    });
});
EOM

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

# Javascript unit tests 
res=\$(script -q /dev/null ./tests/hooks/non-ui-test-hook)
RESULT=\$?
echo \$res
[ \$RESULT -ne 0 ] && exit 1
exit 0
EOM

chmod +x .git/hooks/pre-commit

cat > .git/hooks/post-update << EOM

# Javascript unit tests 
res=\$(script -q /dev/null ./tests/hooks/post-pull)
RESULT=\$?
echo \$res
[ \$RESULT -ne 0 ] && exit 1
exit 0
EOM
chmod +x .git/hooks/post-update

echo "Hooks installed successfully."